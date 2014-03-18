@announce
Feature: Initialization
  As a user, when I initialize Sifttter Redux,
  I should be guided through the process as
  necessary.

  Scenario: Normal Initialization
    Given no file located at "~/.sifttter_redux"
    When I successfully run `srd init`