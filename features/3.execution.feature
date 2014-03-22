@announce
Feature: Execution
  As a user, when I run Sifttter Redux,
  I should have the program exit
  successfully.

  Scenario: Basic Execution
    Given The default aruba timeout is 25 seconds
      And a file located at "/tmp/srd/.sifttter_redux" with the contents:
    """
    ---
    :sifttter_redux:
      :config_location: "/tmp/srd/.sifttter_redux"
      :log_level: WARN
      :version: 0.5.4
      :sifttter_local_filepath: "/tmp/srd/sifttter_download"
      :sifttter_remote_filepath: "/Apps/ifttt/Sifttter"
      :dayone_local_filepath: "/tmp/srd/day_one_download"
      :dayone_remote_filepath: "/Apps/Day\\ One/Journal.dayone/entries"
    :db_uploader:
      :base_filepath: "/usr/local/opt"
      :dbu_filepath: "/usr/local/opt/Dropbox-Uploader"
      :exe_filepath: "/usr/local/opt/Dropbox-Uploader/dropbox_uploader.sh"
    """
      And a file located at "/tmp/srd/.dropbox_uploader" with the contents:
      """
      APPKEY=pbdfy56098906fz
      APPSECRET=7l1t6tnticeast6
      ACCESS_LEVEL=dropbox
      OAUTH_ACCESS_TOKEN=r52iks9mh8rcy5d4
      OAUTH_ACCESS_TOKEN_SECRET=15jk7m0cfzbyp0k
      """
    When I run `srd exec` interactively
    Then the exit status should be 0
  