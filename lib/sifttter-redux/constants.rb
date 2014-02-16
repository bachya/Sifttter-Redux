module SifttterRedux
  VERSION = "0.3.1"
  
  # Sifttter and Sifttter Redux Constants
  SRD_CONFIG_FILEPATH = File.join(ENV['HOME'], '.sifttter_redux')
  SFT_LOCAL_FILEPATH = "/tmp/sifttter"
  SFT_REMOTE_FILEPATH = "/Apps/ifttt/sifttter"

  # Dropbox Upload Constants
  DBU_LOCAL_FILEPATH = "/usr/local/opt"

  # Day One Constants
  DO_REMOTE_FILEPATH = "/Apps/Day\\ One/Journal.dayone/entries"
  DO_LOCAL_FILEPATH = "/tmp/dayone"
end
