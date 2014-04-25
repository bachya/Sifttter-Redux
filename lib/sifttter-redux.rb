require 'sifttter_redux/constants'
require 'sifttter_redux/date_range_maker'
require 'sifttter_redux/dropbox/dropbox_base'
require 'sifttter_redux/dropbox/dropbox_local'
require 'sifttter_redux/dropbox/dropbox_remote'
require 'sifttter_redux/sifttter'

# The SifttterRedux module, which wraps everything
# in this gem.
module SifttterRedux
  class << self
    # Stores whether initalization has completed.
    # @return [Boolean]
    attr_reader :initialized

    # Stores whether verbose output is turned on.
    # @return [Boolean]
    attr_accessor :verbose
  end

  # Removes temporary directories and their contents
  # @return [void]
  def self.cleanup_temp_files
    dirs = [
      configuration.sifttter_redux[:dayone_local_filepath],
      configuration.sifttter_redux[:sifttter_local_filepath]
    ]

    messenger.info_block('Removing temporary local files...') do
      dirs.each do |d|
        FileUtils.rm_rf(d)
        messenger.debug("Removed directory: #{ d }")
      end
    end
  end

  # Runs a wizard that installs Dropbox Uploader on the
  # local filesystem.
  # @param [Boolean] from_scratch
  # @return [void]
  def self.install_dropbox(from_scratch = false)
    # messenger.section('INITIALIZING DROPBOX')
    # pm = CLIUtils::Prefs.new(SifttterRedux::PREF_PROMPT_FILES['DB'], configuration)
    # pm.ask
    # configuration.ingest_prefs(pm)
    #
    # m = "Now, we'll attempt to ask Dropbox for permission to access " \
    # "your newly created app. During this process, you will be taken back " \
    # "to the Drobpbox website to authorize Sifttter Redux to access."
    # messenger.info(m)
    # messenger.prompt('Press enter to continue')
    #
    # tokens = _request_dropbox_tokens
    # if !tokens.empty?
    #   url = "https://www2.dropbox.com/1/oauth/authorize?oauth_token=#{ tokens[:oauth_token].token }"
    #   Launchy.open(url) do |exception|
    #     puts "Failed to open #{ url }: #{ exception }"
    #     return
    #   end
    #
    #   m = "Now, as a last step, we'll attempt to retrieve token data and store it " \
    #   "(so that you are logged into Dropbox going forward)."
    #   messenger.info(m)
    #   messenger.prompt('Press enter to continue')
    #   messenger.info_block('Requesting access token...') do
    #     result = tokens[:request_token].get_access_token(:oauth_verifier => tokens[:oauth_token])
    #     configuration.dropbox[:oauth_access_token] = result.token
    #     configuration.dropbox[:oauth_access_secret] = result.secret
    #   end
    # else
    #   raise 'There was an error getting tokens from Dropbopx'
    # end
  end

  # Creates a date range from the supplied command line
  # options.
  # @param [Hash] options GLI command line options
  # @return [Range]
  def self.get_dates_from_options(options)
    if options[:c] || options[:n] || options[:w] ||
       options[:y] || options[:f] || options[:t] ||
       options[:d]
      # Yesterday
      r = DateRangeMaker.yesterday if options[:y]

      # Specific date
      r = DateRangeMaker.range(options[:d], options[:d]) if options[:d]

      # Current Week
      r = DateRangeMaker.last_n_weeks(0, options[:i]) if options[:c]

      # Last N Days
      r = DateRangeMaker.last_n_days(options[:n].to_i, options[:i]) if options[:n]

      # Last N Weeks
      r = DateRangeMaker.last_n_weeks(options[:w].to_i, options[:i]) if options[:w]

      # Custom Range
      if (options[:f] || options[:t])
        _dates = DateRangeMaker.range(options[:f], options[:t], options[:i])

        if _dates.last > Date.today
          messenger.warn("Ignoring overextended end date and using today's date (#{ Date.today })...")
          r = (_dates.first..Date.today)
        else
          r = (_dates.first.._dates.last)
        end
      end
    else
      r = DateRangeMaker.today
    end

    messenger.debug { "Date range: #{ r }" }
    r
  end

  # Initializes Sifttter Redux by downloading and
  # collecting all necessary items and info.
  # @param [Boolean] from_scratch
  # @return [void]
  def self.init(from_scratch = false)
    if from_scratch
      configuration.reset
      configuration.add_section(:sifttter_redux)
    end

    configuration.sifttter_redux.merge!({
      config_location: configuration.config_path,
      log_level: 'WARN',
      version: SifttterRedux::VERSION,
    })

    # Run the wizard to download Dropbox Uploader.
    install_dropbox(from_scratch = from_scratch)

    messenger.section('INITIALIZING SIFTTTER REDUX')
    pm = CLIUtils::Prefs.new(SifttterRedux::PREF_PROMPT_FILES['INIT'], configuration)
    pm.ask
    configuration.ingest_prefs(pm)

    messenger.debug {"Collected configuration values: #{ configuration.data }" }
    configuration.save
    @initialized = true
  end

  # Notifies the user that the config file needs to be
  # re-done and does it.
  # @return [void]
  def self.update_config_file
    m = "This version needs to make some config changes. Don't worry; " \
        "when prompted, your current values for existing config options " \
        "will be presented (so it'll be easier to fly through the upgrade)."
    messenger.info(m)
    messenger.prompt('Press enter to continue')
    init(true)
  end

  private

  def self._request_dropbox_tokens
    h = {}
    oauth_token = ''
    request_token = ''

    messenger.info_block('Requesting permission to Dropbox...') do
      Dropbox::API::Config.app_key    = configuration.dropbox[:key]
      Dropbox::API::Config.app_secret = configuration.dropbox[:secret]
      if configuration.dropbox[:permission_type] == 'Sandbox'
        Dropbox::API::Config.mode = 'sandbox'
      else
        Dropbox::API::Config.mode = 'dropbox'
      end

      consumer = Dropbox::API::OAuth.consumer(:authorize)
      request_token = consumer.get_request_token
      token = request_token.token
      secret = request_token.secret
      request_token.authorize_url
      hash = { oauth_token: token, oauth_token_secret: secret}
      oauth_token = OAuth::RequestToken.from_hash(consumer, hash)
      h.merge!(request_token: request_token, oauth_token: oauth_token)
    end
    h
  end
end
