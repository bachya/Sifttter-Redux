require "sifttter_redux/cli_message.rb"
require "sifttter_redux/configuration.rb"
require "sifttter_redux/dbu.rb"
require "sifttter_redux/date_range_maker.rb"
require "sifttter_redux/os.rb"

#  ======================================================
#  SifttterRedux Module
#
#  Wrapper module for all other modules in this project
#  ======================================================

module SifttterRedux
  using SifttterRedux::CliMessage
  using SifttterRedux::Configuration
  
  #  ------------------------------------------------------
  #  Constants
  #  ------------------------------------------------------
  DBU_LOCAL_FILEPATH = "/usr/local/opt"
  DO_REMOTE_FILEPATH = "/Apps/Day\\ One/Journal.dayone/entries"
  DO_LOCAL_FILEPATH = "/tmp/dayone"
  SifttterRedux_CONFIG_FILEPATH = File.join(ENV["HOME"], ".sifttter_redux")
  SFT_LOCAL_FILEPATH = "/tmp/sifttter"
  SFT_REMOTE_FILEPATH = "/Apps/ifttt/sifttter"
  
  @verbose_output = true
  
  #  ------------------------------------------------------
  #  initialize_procedures method
  #
  #  Initializes Sifttter Redux by downloading and collecting
  #  all necessary items and info.
  #  @return Void
  #  ------------------------------------------------------
  def self.initialize
    # Re-initialize the configuration data.
    SifttterRedux::Configuration.reset
    SifttterRedux::Configuration.add_section('sifttter_redux')
    SifttterRedux::Configuration['sifttter_redux'].merge!('config_location' => SifttterRedux::Configuration.config_path)

    # Run the wizard to download Dropbox Uploader.
    SifttterRedux::DBU::install_wizard
  
    # Collect other misc. preferences.
    SifttterRedux::CliMessage.section('COLLECTING PREFERENCES...')
    pref_prompts = [
      {
        prompt: 'Location for downloaded Sifttter files from Dropbox',
        default: SifttterRedux::SFT_LOCAL_FILEPATH,
        key: 'sifttter_local_filepath',
        section: 'sifttter_redux'
      },
      {
        prompt: 'Location of Sifttter files in Dropbox',
        default: SifttterRedux::SFT_REMOTE_FILEPATH,
        key: 'sifttter_remote_filepath',
        section: 'sifttter_redux'
      },
      {
        prompt: 'Location for downloaded Day One files from Dropbox',
        default: SifttterRedux::DO_LOCAL_FILEPATH,
        key: 'dayone_local_filepath',
        section: 'sifttter_redux'
      },
      {
        prompt: 'Location of Day One files in Dropbox',
        default: SifttterRedux::DO_REMOTE_FILEPATH,
        key: 'dayone_remote_filepath',
        section: 'sifttter_redux'
      }
    ]
  
    pref_prompts.each do |prompt|
      pref = SifttterRedux::CliMessage.prompt(prompt[:prompt], prompt[:default])
      SifttterRedux::Configuration[prompt[:section]].merge!(prompt[:key] => pref)
    end

    SifttterRedux::Configuration.save
  end
  
  def self.verbose
    @verbose_output
  end
  
  def self.verbose=(verbose)
    @verbose_output = verbose
  end
end