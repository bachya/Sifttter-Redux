# 0.6.0 (2014-04-01)

* Migrated to CLIUtils

# 0.5.4 (2014-03-19)

* Fixed several bugs related to configuration management

# 0.5.3 (2014-03-18)

* Fixed regression with gemspec

# 0.5.2 (2014-03-18)

* New Configuration management system

# 0.5.1 (2014-03-18)

* Fixed a bug regarding missing Methadone references

# 0.5.0 (2014-03-16)

* Fixed a bug where Dropbox Uploader would fail when not in "verbose mode"

# 0.4.9 (2014-03-15)

* Fixed a bug with importing Logger into CLIMessage

# 0.4.8 (2014-03-15)

* Fixed a bug in which Sifttter Redux would ignore log level specified in config file
* Made all prompt entry readline-based (for easier completion options)

# 0.4.7 (2014-03-14)

* Reworked logging to not require Methadone
* Logging more verbose and configurable in ~/.sifttter_redux
* Dropbox Uploader updates
* Added support for path completion when prompting user to enter a filepath
* Cleaned up error handling to be displayed to user at single point

# 0.4.6 (2014-03-13)

* Added new error messaaging if Sifttter remote path is invalid
* Removed dependencies on exernal UUID library
* Removed OS module (not needed anymore)

# 0.4.5 (2014-03-01)

* Added Methadone logging for prompts

# 0.4.4 (2014-02-28)

* Fixed a prompt error when providing Dropbox-Uploader with a bad path

# 0.4.3 (2014-02-26)

* Fixed regression with Dropbox-Uploader

# 0.4.2 (2014-02-26)

* Fixed regression with Dropbox-Uploader

# 0.4.1 (2014-02-26)

* Added `-s` flag to `init` command for initialization from scratch
* Added gem version to config file (for reference going forward)
* Added message to prompt users to re-init on upgrade

# 0.4.0 (2014-02-26)

* Removed some hardcoded values

# 0.3.9 (2014-02-25)

* Smarter checking for initialization before execution
* Fixed a bug in which the config file wouldn't be properly written to

# 0.3.8 (2014-02-25)

* Upgraded to Methadone 1.3.2 in gemspec
* Redirected all Methadone logging to file
* Fixed a bug in which initailization would fail under certain circumstances
* Fixed a bug in which Dropbox Uploader would fail to initialize properly

# 0.3.7 (2014-02-25)

* Fixed a bug in which Sifttter-Redux would fail on Ruby 2.0.0 (and potentially others)

# 0.3.6 (2014-02-21)

* Added logging via Methadone (key interactions logged to ~/.sifttter\_redux\_log)

# 0.3.5 (2014-02-21)

* Updated documentation and usage message

# 0.3.4 (2014-02-21)

* Automatically configure Dropbox Uploader during init (if needed)
* Fixed several small bugs
* Added more test cases

# 0.3.3 (2014-02-20)

* Fixed a bug in which the SifttterRedux module wouldn't load

# 0.3.2 (2014-02-20)

* Added verbose flag
* Big refactorings = much nicer, more modular code
* Removed dependency on colored gem

# 0.3.1

* Removed reliance on Rails methods for first-and-last-day-of-week calculations
* Fixed a bug with the gemspec

# 0.3.0

* Added ability to create entries for the past N days (not just 7)
* Added ability to create entries for the past N weeks
* Refactorings of existing DateRangeMaker class
* Additional documentation
* Fixed a bug with using Chronic's language parsing using `-f`

# 0.2.5

* Fixed a bug where execution could prematurely halt if no Day One entries were found
* Fixed a bug where re-initialization could continue, even if user declines
* Updated some more help documentation
* Changed messaging for initialization completion

# 0.2.4 (originally 0.2.3)

* Updated some help documentation
* Changed message re: no entries found to a warning state

# 0.2.2

* Fixed a bug caused by caching of old configuration results

# 0.2.1

* Fixed a bug where the config manager would fail on certain platforms
* Fixed a bug where the path to Dropbox Uploader became malformed

# 0.2.0

* Implemented catch-up mode

# 0.1.0

* Initial release of Sifttter Redux