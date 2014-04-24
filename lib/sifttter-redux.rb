require 'sifttter-redux/constants'
require 'sifttter-redux/date-range-maker'
require 'sifttter-redux/dropbox-uploader'
require 'sifttter-redux/sifttter'

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
  def self.dbu_install_wizard(from_scratch = false)
    valid_path_chosen = false

    until valid_path_chosen
      # Prompt the user for a location to save Dropbox Uploader.
      if from_scratch && !configuration.db_uploader[:base_filepath].nil?
        default = configuration.db_uploader[:base_filepath]
      else
        default = DEFAULT_DBU_LOCAL_FILEPATH
      end
      path = messenger.prompt('Location for Dropbox-Uploader', default)
      path = default if path.empty?
      path.chop! if path.end_with?('/')

      # If the entered directory exists, clone the repository.
      if Dir.exists?(File.expand_path(path))
        valid_path_chosen = true

        dbu_path = File.join(path, 'Dropbox-Uploader')
        executable_path = File.join(dbu_path, 'dropbox_uploader.sh')

        if File.directory?(dbu_path)
          messenger.warn("Using pre-existing Dropbox Uploader at #{ dbu_path }...")
        else
          messenger.info_block("Downloading Dropbox Uploader to #{ dbu_path }...", 'Done.', true) do
            system "git clone https://github.com/andreafabrizi/Dropbox-Uploader.git #{ dbu_path }"
          end
        end

        # If the user has never configured Dropbox Uploader, have them do it here.
        unless File.exists?(DEFAULT_DBU_CONFIG_FILEPATH)
          messenger.info_block('Initializing Dropbox Uploader...') { system "#{ executable_path }" }
        end

        configuration.add_section(:db_uploader) unless configuration.data.key?(:db_uploader)
        configuration.db_uploader.merge!({
          base_filepath: path,
          dbu_filepath: dbu_path,
          exe_filepath: executable_path
        })
      else
        messenger.error("Sorry, but #{ path } isn't a valid directory.")
      end
    end
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
    dbu_install_wizard(from_scratch = from_scratch)

    pm = CLIUtils::Prefs.new(SifttterRedux::PREF_FILES['INIT'], configuration)
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
    SifttterRedux.init(true)
  end
end
