require "sifttter_redux/cli_message.rb"
require "sifttter_redux/configuration.rb"
require "sifttter_redux/date_range_maker.rb"
require "sifttter_redux/os.rb"

module SifttterRedux
  # Sifttter and Sifttter Redux Constants
  SRD_CONFIG_FILEPATH = File.join(ENV["HOME"], ".sifttter_redux")
  SFT_LOCAL_FILEPATH = "/tmp/sifttter"
  SFT_REMOTE_FILEPATH = "/Apps/ifttt/sifttter"

  # Dropbox Uploader Constants
  DBU_LOCAL_FILEPATH = "/usr/local/opt"

  # Day One Constants
  DO_REMOTE_FILEPATH = "/Apps/Day\\ One/Journal.dayone/entries"
  DO_LOCAL_FILEPATH = "/tmp/dayone"
end