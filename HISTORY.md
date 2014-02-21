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