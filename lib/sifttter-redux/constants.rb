module SifttterRedux
  # The default configuration path for Dropbox Uploader
  DEFAULT_DBU_CONFIG_FILEPATH = File.join(ENV['HOME'], '.dropbox_uploader')

  # The default local filepath of the Dropbox-Uploader directory
  DEFAULT_DBU_LOCAL_FILEPATH = '/usr/local/opt'

  # The default message to display when Dropbox Uploader is running
  DEFAULT_DBU_MESSAGE = 'RUNNING DROPBOX UPLOADER'

  # The default local filepath of the Siftter Redux config file
  DEFAULT_SRD_CONFIG_FILEPATH = File.join(ENV['HOME'], '.sifttter_redux')

  # The default local filepath of the Siftter Redux log file
  DEFAULT_SRD_LOG_FILEPATH = File.join(ENV['HOME'], '.sifttter_redux_log')

  # The Gem's description
  DESCRIPTION = 'A customized IFTTT-to-Day One service that allows for smart installation and automated running on a standalone *NIX device (such as a Raspberry Pi).'

  # The last version to require a config update
  NEWEST_CONFIG_VERSION = '0.6'

  # Hash of preference files
  PREF_FILES = {
    'INIT' => File.join(File.dirname(__FILE__), '..', '..', 'res/preference_prompts.yaml')
  }

  # The Gem's summary
  SUMMARY = 'Automated IFTTT to Day One engine.'

  # The Gem's version
  VERSION = '1.0.0.pre'
end