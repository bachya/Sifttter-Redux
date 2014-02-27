require 'sifttter_redux/cli_message.rb'
require 'sifttter_redux/configuration.rb'
require 'sifttter_redux/date_range_maker.rb'
require 'sifttter_redux/dbu.rb'
require 'sifttter_redux/os.rb'
require 'sifttter_redux/sifttter.rb'
require 'sifttter_redux/version.rb'

#  ======================================================
#  SifttterRedux Module
#
#  Wrapper module for all other modules in this project
#  ======================================================

module SifttterRedux

  #  ----------------------------------------------------
  #  Constants
  #  ----------------------------------------------------
  DBU_LOCAL_FILEPATH = '/usr/local/opt'
  DO_REMOTE_FILEPATH = "/Apps/Day\\ One/Journal.dayone/entries"
  DO_LOCAL_FILEPATH = '/tmp/dayone'
  SRD_CONFIG_FILEPATH = File.join(ENV['HOME'], '.sifttter_redux')
  SRD_LOG_FILEPATH = File.join(ENV['HOME'], '.sifttter_redux_log')
  SFT_LOCAL_FILEPATH = '/tmp/sifttter'
  SFT_REMOTE_FILEPATH = '/Apps/ifttt/sifttter'

  @verbose_output = true

  #  ----------------------------------------------------
  #  initialize_procedures method
  #
  #  Initializes Sifttter Redux by downloading and
  #  collecting all necessary items and info.
  #  @return Void
  #  ----------------------------------------------------
  def self.init(already_initialized = false)
    # Re-initialize the configuration data.
    Configuration::add_section('sifttter_redux') unless Configuration::section_exists?('sifttter_redux')
    Configuration['sifttter_redux'].merge!('version' => VERSION, 'config_location' => Configuration::config_path)

    # Run the wizard to download Dropbox Uploader.
    DBU::install_wizard(already_initialized = already_initialized)

    # Collect other misc. preferences.
    CLIMessage::section_block('COLLECTING PREFERENCES...') do
      pref_prompts = [
        {
          prompt: 'Location for downloaded Sifttter files from Dropbox',
          default: already_initialized ? Configuration['sifttter_redux']['sifttter_local_filepath'] : SFT_LOCAL_FILEPATH,
          key: 'sifttter_local_filepath',
          section: 'sifttter_redux'
        },
        {
          prompt: 'Location of Sifttter files in Dropbox',
          default: already_initialized ? Configuration['sifttter_redux']['sifttter_remote_filepath'] : SFT_REMOTE_FILEPATH,
          key: 'sifttter_remote_filepath',
          section: 'sifttter_redux'
        },
        {
          prompt: 'Location for downloaded Day One files from Dropbox',
          default: already_initialized ? Configuration['sifttter_redux']['dayone_local_filepath'] : DO_LOCAL_FILEPATH,
          key: 'dayone_local_filepath',
          section: 'sifttter_redux'
        },
        {
          prompt: 'Location of Day One files in Dropbox',
          default: already_initialized ? Configuration['sifttter_redux']['dayone_remote_filepath'] : DO_REMOTE_FILEPATH,
          key: 'dayone_remote_filepath',
          section: 'sifttter_redux'
        }
      ]

      pref_prompts.each do |prompt|
        pref = CLIMessage::prompt(prompt[:prompt], prompt[:default])
        Configuration[prompt[:section]].merge!(prompt[:key] => pref)
      end
    end
    
    Methadone::CLILogging.info("Configuration values: #{ Configuration::dump }")
    
    Configuration::save
  end

  #  ----------------------------------------------------
  #  verbose method
  #
  #  Returns the verbosity state.
  #  @return Bool
  #  ----------------------------------------------------
  def self.verbose
    @verbose_output
  end

  #  ----------------------------------------------------
  #  verbose= method
  #
  #  Sets the verbosity state.
  #  @return Void
  #  ----------------------------------------------------
  def self.verbose=(verbose)
    @verbose_output = verbose
  end

end