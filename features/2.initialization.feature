@announce
Feature: Initialization
  As a user, when I initialize Sifttter Redux,
  I should be guided through the process as
  necessary.

  Scenario: Basic Initialization
    Given no file located at "~/.sifttter_redux"
    When I run `srd init` interactively
      And I type "~\n"
      And I type "~/sifttter_download\n"
      And I type "/Apps/ifttt/Sifttter\n"
      And I type "~/day_one_download\n"
      And I type "/Apps/Day\ One/Journal.dayone/entries\n"
    Then the file "~/.sifttter_redux" should contain:
    """
    asdasd
    """
      