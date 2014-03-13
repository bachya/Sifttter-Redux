require 'sifttter_redux/cli_message.rb'
require 'sifttter_redux/configuration.rb'
require 'sifttter_redux/date_range_maker.rb'
require 'sifttter_redux/dbu.rb'
require 'sifttter_redux/sifttter.rb'
require 'sifttter_redux/version.rb'

#  ======================================================
#  SifttterRedux Module
#
#  Wrapper module for all other modules in this project
#  ======================================================

module SifttterRedux
  attr_accessor :verbose

  #  ====================================================
  #  Constants
  #  ====================================================
  DBU_LOCAL_FILEPATH = '/usr/local/opt'

  DO_LOCAL_FILEPATH = '/tmp/dayone'
  DO_REMOTE_FILEPATH = "/Apps/Day\\ One/Journal.dayone/entries"

  SFT_LOCAL_FILEPATH = '/tmp/sifttter'
  SFT_REMOTE_FILEPATH = '/Apps/ifttt/sifttter'

  SRD_CONFIG_FILEPATH = File.join(ENV['HOME'], '.sifttter_redux')
  SRD_LOG_FILEPATH = File.join(ENV['HOME'], '.sifttter_redux_log')

  #  ====================================================
  #  Methods
  #  ====================================================
  #  ----------------------------------------------------
  #  cleanup_temp_files method
  #
  #  Removes temporary directories and their contents
  #  @return Void
  #  ----------------------------------------------------
  def self.cleanup_temp_files
    dirs = [
      Configuration['sifttter_redux']['dayone_local_filepath'],
      Configuration['sifttter_redux']['sifttter_local_filepath']
    ]

    CLIMessage::info_block('Removing temporary local files...') { dirs.each { |d| FileUtils.rm_rf(d) } }
  end

  #  ----------------------------------------------------
  #  get_dates_from_options method
  #
  #  Creates a date range from the supplied command line
  #  options.
  #  @param options A Hash of command line options
  #  @return Range
  #  ----------------------------------------------------
  def self.get_dates_from_options(options)
    CLIMessage::section_block('EXECUTING...') do
      if options[:c] || options[:n] || options[:w] || options[:y] || options[:f] || options[:t]
        # Yesterday
        DateRangeMaker.yesterday if options[:y]

        # Current Week
        DateRangeMaker.last_n_weeks(0, options[:i]) if options[:c]
        
        # Last N Days
        DateRangeMaker.last_n_days(options[:n].to_i, options[:i]) if options[:n]

        # Last N Weeks
        DateRangeMaker.last_n_weeks(options[:w].to_i, options[:i]) if options[:w]

        # Custom Range
        if (options[:f] || options[:t])
          begin
            _dates = DateRangeMaker.range(options[:f], options[:t], options[:i])

            if _dates.last > Date.today
              long_message = "Ignoring overextended end date and using today's date (#{ Date.today })..."
              CLIMessage::warning(long_message)
              (_dates.first..Date.today)
            else
              (_dates.first.._dates.last)
            end
          rescue ArgumentError => e
            CLIMessage::error(e)
          end
        end
      else
        DateRangeMaker.today
      end
    end
  end

  #  ----------------------------------------------------
  #  initialize_procedures method
  #
  #  Initializes Sifttter Redux by downloading and
  #  collecting all necessary items and info.
  #  @return Void
  #  ----------------------------------------------------
  def self.init(reinit = false)
    unless reinit
      Configuration::reset
      Configuration::add_section('sifttter_redux')
    end
    Configuration['sifttter_redux'].merge!('version' => VERSION, 'config_location' => Configuration::config_path)

    # Run the wizard to download Dropbox Uploader.
    DBU::install_wizard(reinit = reinit)

    # Collect other misc. preferences.
    CLIMessage::section_block('COLLECTING PREFERENCES...') do
      pref_prompts = [
        {
          prompt: 'Location for downloaded Sifttter files from Dropbox',
          default: SFT_LOCAL_FILEPATH,
          key: 'sifttter_local_filepath',
          section: 'sifttter_redux'
        },
        {
          prompt: 'Location of Sifttter files in Dropbox',
          default: SFT_REMOTE_FILEPATH,
          key: 'sifttter_remote_filepath',
          section: 'sifttter_redux'
        },
        {
          prompt: 'Location for downloaded Day One files from Dropbox',
          default: DO_LOCAL_FILEPATH,
          key: 'dayone_local_filepath',
          section: 'sifttter_redux'
        },
        {
          prompt: 'Location of Day One files in Dropbox',
          default: DO_REMOTE_FILEPATH,
          key: 'dayone_remote_filepath',
          section: 'sifttter_redux'
        }
      ]

      pref_prompts.each do |prompt|
        d = reinit ? Configuration[prompt[:section]][prompt[:key]] : prompt[:default]
        pref = CLIMessage::prompt(prompt[:prompt], d)

        Configuration[prompt[:section]].merge!(prompt[:key] => File.expand_path(pref))
      end
    end

    Methadone::CLILogging.info("Configuration values: #{ Configuration::dump }")
    Configuration::save
  end
end