Sifttter Redux
==============
[![Build Status](https://travis-ci.org/bachya/Sifttter-Redux.svg?branch=master)](https://travis-ci.org/bachya/Sifttter-Redux)
[![Gem Version](https://badge.fury.io/rb/sifttter-redux.svg)](http://badge.fury.io/rb/sifttter-redux)

# Upgrading From 0.x.x to 1.0.0?

Make sure you read the [IFTTT Template](#ifttt-template) section.

# Intro

Siftter Redux is a modification of Craig Eley's
[Sifttter](http://craigeley.com/post/72565974459/sifttter-an-ifttt-to-day-one-logger "Sifttter"),
a script to collect information from [IFTTT](http://www.ifttt.com "IFTTT") and
place it in a [Day One](http://dayoneapp.com, "Day One") journal.

Siftter Redux has several fundamental differences:

* Interactive logging of today's events or events in the past
* "Catch Up" mode for logging several days' events at once
* Packaged as a command line app, complete with documentation and help
* Easy installation on cron for automated running

# Prerequisites

In addition to Git (which, given you being on this site, I'll assume you have),
Ruby (v. 1.9.3 or greater) is needed.

# Installation

```
gem install sifttter-redux
```

# Usage

Syntax and usage can be accessed by running `srd help`:

```
$ srd help
NAME
    srd - Sifttter Redux

    A customized IFTTT-to-Day One service that allows for
    smart installation and automated running on a standalone
    *NIX device (such as a Raspberry Pi).

SYNOPSIS
    srd [global options] command [command options] [arguments...]

VERSION
   1.0.6

GLOBAL OPTIONS
    --help         - Show this message
    --[no-]verbose - Turns on verbose output
    --version      - Display the program version

COMMANDS
    exec - Execute the script
    help - Shows a list of commands or help for one command
    init - Install and initialize dependencies
```

Note that each command's options can be revealed by adding the `--help` switch
after the command. For example:

```
$ srd exec --help
NAME
    exec - Execute the script

SYNOPSIS
    srd [global options] exec [command options]

COMMAND OPTIONS
    -c             - Run catch-up mode from the beginning of the week to yesterday
    -f arg         - Run catch-up mode with this start date (default: none)
    -i             - Include today's date in catch-up
    -n arg         - Run catch-up mode for the last N days (default: none)
    -t arg         - Run catch-up mode with this end date (must also have -f) (default: none)
    --[no-]verbose - Turns on verbose output
    -w arg         - Run catch-up mode for the last N weeks (default: none)
    -y             - Run catch-up mode for yesterday
```

## IFTTT Template

Version 1.0.0+ uses a new schema that allows for any type of Markdown. Thus, Sifttter
files from IFTTT need to follow this format:

```
@begin
@date April 21, 2014 at 12:34PM
**Any** sort of *Markdown* goes here...
@end
```

Whereas the previous Sifttter Redux only allowed output of bulleted lists, this new 
template style allows you to include *any* Markdown, making output like tables possibe.

### Upgrade Command

Note that a new command has been introduced that attempts to upgrade to this
new format. **Although the command backs up your current Sifttter files, you
are strongly encouraged to make a separate, manual backup.**

```Bash
$ srd upgrade
```

### Template Tokens

IFTTT templates can make use of the following tokens:

* `%time%`: the time the entry was created

As an example, to include the entry time in a template:

```
@begin
@date April 21, 2014 at 12:34PM
- %time%: My text goes here...
@end
```

## Initialization

```
$ srd init
```

Initialization will perform the following steps:

1. Download [Dropbox Uploader](https://github.com/andreafabrizi/Dropbox-Uploader "Dropbox-Uploder")
to a location of your choice.
2. Automatically configure Dropbox Uploader.
3. Collect some user paths (note that you can use tab completion here!):
 * The location on your filesystem where Sifttter files will be temporarily stored
 * The location of your Sifttter files in Dropbox
 * The location on your filesystem where Day One files will be temporarily stored
 * The location of your Day One files in Dropbox

## Pathing

Note that when Sifttter Redux asks you for paths, it will ask for "local" and
"remote" filepaths. It's important to understand the difference.

### Local Filepaths

Local filepaths are, as you'd expect, filepaths on your local machine. Some
examples might be:

* `/tmp/my_data`
* `/home/bob/ifttt/sifttter_data`
* `~/sifttter`

### Remote Filepaths

Remote filepaths, on the other hand, are absolute filepaths in your Dropbox
folder (*as Dropbox Uploader would see them*). For instance,
`/home/bob/Dropbox/apps/sifttter` is *not* a valid remote filepath; rather,
`/apps/sifttter` would be correct.

## Basic Execution

```
$ srd exec
#### EXECUTING...
---> INFO: Creating entry for February 15, 2014...
---> INFO: Downloading Sifttter files...DONE.
---> SUCCESS: Entry logged for February 15, 2014...
---> INFO: Uploading Day One entries to Dropbox...DONE.
---> INFO: Removing downloaded Day One files...DONE.
---> INFO: Removing downloaded Sifttter files...DONE.
#### EXECUTION COMPLETE!
```

## "Catch-up" Mode

Sometimes, events occur that prevent Sifttter Redux from running (power loss to
  your device, a bad Cron job, etc.). In this case, Sifttter Redux's "catch-up"
  mode can be used to collect any valid journal on or before today's date.

There are many ways to use this mode (note that "today" in these examples is
**February 15, 2014**):

### Yesterday Catch-up

To create an entry for yesterday:

```
$ srd exec -y
#### EXECUTING...
---> INFO: Creating entry for February 14, 2014...
---> INFO: Downloading Sifttter files...DONE.
---> SUCCESS: Entry logged for February 14, 2014...
---> INFO: Uploading Day One entries to Dropbox...DONE.
---> INFO: Removing downloaded Day One files...DONE.
---> INFO: Removing downloaded Sifttter files...DONE.
#### EXECUTION COMPLETE!
```

### Catch-up for a Specific Date

To create an entry for specific date:

```
$ srd exec -d 2014-02-14
#### EXECUTING...
---> INFO: Creating entry for February 14, 2014...
---> INFO: Downloading Sifttter files...DONE.
---> SUCCESS: Entry logged for February 14, 2014...
---> INFO: Uploading Day One entries to Dropbox...DONE.
---> INFO: Removing downloaded Day One files...DONE.
---> INFO: Removing downloaded Sifttter files...DONE.
#### EXECUTION COMPLETE!
```

### Last "N" Days Catch-up

Sifttter Redux allows you to specify the number of days back it should look for
new entries:

```
$ srd exec -n 3
#### EXECUTING...
---> INFO: Creating entries for dates from February 12, 2014 to February 14, 2014...
---> INFO: Downloading Sifttter files...DONE.
---> SUCCESS: Entry logged for February 12, 2014...
---> SUCCESS: Entry logged for February 13, 2014...
---> SUCCESS: Entry logged for February 14, 2014...
---> INFO: Uploading Day One entries to Dropbox...DONE.
---> INFO: Removing downloaded Day One files...DONE.
---> INFO: Removing downloaded Sifttter files...DONE.
#### EXECUTION COMPLETE!

$ srd exec -n 12
#### EXECUTING...
---> INFO: Creating entries for dates from February 03, 2014 to February 14, 2014...
---> INFO: Downloading Sifttter files...DONE.
---> SUCCESS: February 03, 2014...
---> SUCCESS: February 04, 2014...
---> SUCCESS: February 05, 2014...
---> SUCCESS: February 06, 2014...
---> SUCCESS: February 07, 2014...
---> SUCCESS: February 08, 2014...
---> SUCCESS: February 09, 2014...
---> SUCCESS: February 10, 2014...
---> SUCCESS: February 11, 2014...
---> SUCCESS: February 12, 2014...
---> SUCCESS: February 13, 2014...
---> SUCCESS: February 14, 2014...
---> INFO: Uploading Day One entries to Dropbox...DONE.
---> INFO: Removing downloaded Day One files...DONE.
---> INFO: Removing downloaded Sifttter files...DONE.
#### EXECUTION COMPLETE!
```

Note that this option goes until yesterday ("yesterday" because you might not be
ready to have today's entries scanned). If you'd rather include today's date, you
can always add the `-i` switch:

```
$ srd exec -i -n 3
#### EXECUTING...
---> INFO: Creating entries for dates from February 12, 2014 to February 15, 2014...
---> INFO: Downloading Sifttter files...DONE.
---> SUCCESS: Entry logged for February 12, 2014...
---> SUCCESS: Entry logged for February 13, 2014...
---> SUCCESS: Entry logged for February 14, 2014...
---> SUCCESS: Entry logged for February 15, 2014...
---> INFO: Uploading Day One entries to Dropbox...DONE.
---> INFO: Removing downloaded Day One files...DONE.
---> INFO: Removing downloaded Sifttter files...DONE.
#### EXECUTION COMPLETE!
```

### Last "N" Weeks Catch-up

Sifttter Redux also allows you to specify a number of weeks back that should be
scanned for new entries:

```
$ srd exec -w 1
#### EXECUTING...
---> INFO: Creating entries for dates from February 03, 2014 to February 14, 2014...
---> INFO: Downloading Sifttter files...DONE.
---> SUCCESS: Entry logged for February 03, 2014...
---> SUCCESS: Entry logged for February 04, 2014...
---> SUCCESS: Entry logged for February 05, 2014...
---> SUCCESS: Entry logged for February 06, 2014...
---> SUCCESS: Entry logged for February 07, 2014...
---> SUCCESS: Entry logged for February 08, 2014...
---> SUCCESS: Entry logged for February 09, 2014...
---> SUCCESS: Entry logged for February 10, 2014...
---> SUCCESS: Entry logged for February 11, 2014...
---> SUCCESS: Entry logged for February 12, 2014...
---> SUCCESS: Entry logged for February 13, 2014...
---> SUCCESS: Entry logged for February 14, 2014...
---> INFO: Uploading Day One entries to Dropbox...DONE.
---> INFO: Removing downloaded Day One files...DONE.
---> INFO: Removing downloaded Sifttter files...DONE.
#### EXECUTION COMPLETE!

$ srd exec -w 3
#### EXECUTING...
---> INFO: Creating entries for dates from January 20, 2014 to February 14, 2014...
---> INFO: Downloading Sifttter files...DONE.
---> SUCCESS: Entry logged for January 20, 2014...
---> SUCCESS: Entry logged for January 21, 2014...
---> SUCCESS: Entry logged for January 22, 2014...
---> SUCCESS: Entry logged for January 23, 2014...
---> SUCCESS: Entry logged for January 24, 2014...
---> SUCCESS: Entry logged for January 25, 2014...
---> SUCCESS: Entry logged for January 26, 2014...
---> SUCCESS: Entry logged for January 27, 2014...
---> SUCCESS: Entry logged for January 28, 2014...
---> SUCCESS: Entry logged for January 29, 2014...
---> SUCCESS: Entry logged for January 30, 2014...
---> SUCCESS: Entry logged for January 31, 2014...
---> SUCCESS: Entry logged for February 01, 2014...
---> SUCCESS: Entry logged for February 02, 2014...
---> SUCCESS: Entry logged for February 03, 2014...
---> SUCCESS: Entry logged for February 04, 2014...
---> SUCCESS: Entry logged for February 05, 2014...
---> SUCCESS: Entry logged for February 06, 2014...
---> SUCCESS: Entry logged for February 07, 2014...
---> SUCCESS: Entry logged for February 08, 2014...
---> SUCCESS: Entry logged for February 09, 2014...
---> SUCCESS: Entry logged for February 10, 2014...
---> SUCCESS: Entry logged for February 11, 2014...
---> SUCCESS: Entry logged for February 12, 2014...
---> SUCCESS: Entry logged for February 13, 2014...
---> SUCCESS: Entry logged for February 14, 2014...
---> INFO: Uploading Day One entries to Dropbox...DONE.
---> INFO: Removing downloaded Day One files...DONE.
---> INFO: Removing downloaded Sifttter files...DONE.
#### EXECUTION COMPLETE!
```

As you'd expect, you can always add the `-i` switch:

```
$ srd exec -i -w 1
#### EXECUTING...
---> INFO: Creating entries for dates from February 03, 2014 to February 15, 2014...
---> INFO: Downloading Sifttter files...DONE.
---> SUCCESS: Entry logged for February 03, 2014...
---> SUCCESS: Entry logged for February 04, 2014...
---> SUCCESS: Entry logged for February 05, 2014...
---> SUCCESS: Entry logged for February 06, 2014...
---> SUCCESS: Entry logged for February 07, 2014...
---> SUCCESS: Entry logged for February 08, 2014...
---> SUCCESS: Entry logged for February 09, 2014...
---> SUCCESS: Entry logged for February 10, 2014...
---> SUCCESS: Entry logged for February 11, 2014...
---> SUCCESS: Entry logged for February 12, 2014...
---> SUCCESS: Entry logged for February 13, 2014...
---> SUCCESS: Entry logged for February 14, 2014...
---> SUCCESS: Entry logged for February 15, 2014...
---> INFO: Uploading Day One entries to Dropbox...DONE.
---> INFO: Removing downloaded Day One files...DONE.
---> INFO: Removing downloaded Sifttter files...DONE.
#### EXECUTION COMPLETE!
```

### Date Range Catch-up

To create entries for a range of dates:

```
$ srd exec -f 2014-02-01 -t 2014-02-12
#### EXECUTING...
---> INFO: Creating entries for dates from February 01, 2014 to February 12, 2014...
---> INFO: Downloading Sifttter files...DONE.
---> SUCCESS: Entry logged for February 01, 2014...
---> SUCCESS: Entry logged for February 02, 2014...
---> SUCCESS: Entry logged for February 03, 2014...
---> SUCCESS: Entry logged for February 04, 2014...
---> SUCCESS: Entry logged for February 05, 2014...
---> SUCCESS: Entry logged for February 06, 2014...
---> SUCCESS: Entry logged for February 07, 2014...
---> SUCCESS: Entry logged for February 08, 2014...
---> SUCCESS: Entry logged for February 09, 2014...
---> SUCCESS: Entry logged for February 10, 2014...
---> SUCCESS: Entry logged for February 11, 2014...
---> SUCCESS: Entry logged for February 12, 2014...
---> INFO: Uploading Day One entries to Dropbox...DONE.
---> INFO: Removing downloaded Day One files...DONE.
---> INFO: Removing downloaded Sifttter files...DONE.
#### EXECUTION COMPLETE!
```

Even more simply, to create entries from a specific point until yesterday
("yesterday" because you might not be ready to have today's entries scanned):

```
$ srd exec -f 2014-02-01
#### EXECUTING...
---> INFO: Creating entries for dates from February 01, 2014 to February 12, 2014...
---> INFO: Downloading Sifttter files...DONE.
---> SUCCESS: Entry logged for February 01, 2014...
---> SUCCESS: Entry logged for February 02, 2014...
---> SUCCESS: Entry logged for February 03, 2014...
---> SUCCESS: Entry logged for February 04, 2014...
---> SUCCESS: Entry logged for February 05, 2014...
---> SUCCESS: Entry logged for February 06, 2014...
---> SUCCESS: Entry logged for February 07, 2014...
---> SUCCESS: Entry logged for February 08, 2014...
---> SUCCESS: Entry logged for February 09, 2014...
---> SUCCESS: Entry logged for February 10, 2014...
---> SUCCESS: Entry logged for February 11, 2014...
---> SUCCESS: Entry logged for February 12, 2014...
---> INFO: Uploading Day One entries to Dropbox...DONE.
---> INFO: Removing downloaded Day One files...DONE.
---> INFO: Removing downloaded Sifttter files...DONE.
#### EXECUTION COMPLETE!
```

In this case, once more, you can use the trusty `-i` switch if you want:

```
$ srd exec -i -f 2014-02-01
#### EXECUTING...
---> INFO: Creating entries for dates from February 01, 2014 to February 15, 2014...
---> INFO: Downloading Sifttter files...DONE.
---> SUCCESS: Entry logged for February 01, 2014...
---> SUCCESS: Entry logged for February 02, 2014...
---> SUCCESS: Entry logged for February 03, 2014...
---> SUCCESS: Entry logged for February 04, 2014...
---> SUCCESS: Entry logged for February 05, 2014...
---> SUCCESS: Entry logged for February 06, 2014...
---> SUCCESS: Entry logged for February 07, 2014...
---> SUCCESS: Entry logged for February 08, 2014...
---> SUCCESS: Entry logged for February 09, 2014...
---> SUCCESS: Entry logged for February 10, 2014...
---> SUCCESS: Entry logged for February 11, 2014...
---> SUCCESS: Entry logged for February 12, 2014...
---> SUCCESS: Entry logged for February 13, 2014...
---> SUCCESS: Entry logged for February 14, 2014...
---> SUCCESS: Entry logged for February 15, 2014...
---> INFO: Uploading Day One entries to Dropbox...DONE.
---> INFO: Removing downloaded Day One files...DONE.
---> INFO: Removing downloaded Sifttter files...DONE.
#### EXECUTION COMPLETE!
```

Two notes to be aware of:

* `-f` and `-t` are *inclusive* parameters, meaning that when specified, those
dates will be included when searching for Siftter data.
* Although you can specify `-f` by itself, you cannot specify `-t` by itself.

Sifttter Redux makes use of the excellent
[Chronic gem](https://github.com/mojombo/chronic "Chronic"), which provides
natural language parsing for dates and times. This means that you can run
commands with more "human" dates:

```
$ srd exec -f "last monday" -t "yesterday"
#### EXECUTING...
---> INFO: Creating entries for dates from February 10, 2014 to February 14, 2014...
---> INFO: Downloading Sifttter files...DONE.
---> SUCCESS: Entry logged for February 10, 2014...
---> SUCCESS: Entry logged for February 11, 2014...
---> SUCCESS: Entry logged for February 12, 2014...
---> SUCCESS: Entry logged for February 13, 2014...
---> SUCCESS: Entry logged for February 14, 2014...
---> INFO: Uploading Day One entries to Dropbox...DONE.
---> INFO: Removing downloaded Day One files...DONE.
---> INFO: Removing downloaded Sifttter files...DONE.
#### EXECUTION COMPLETE!
```

See [Chronic's Examples section](https://github.com/mojombo/chronic#examples "Chronic Examples")
for more examples.

# Cron Job

By installing an entry to a `crontab`, Sifttter Redux can be run automatically
on a schedule. The aim of this project was to use a Raspberry Pi; as such, the
instructions below are specifically catered to that platform. That said, it
should be possible to install and configure on any *NIX platform.

One issue that arises is the loading of the bundled gems; because cron runs in a
limited environment, it does not automatically know where to find installed gems.

## Using RVM

If your Raspberry Pi uses RVM, this `crontab` entry will do:

```
55 23 * * * /bin/bash -l -c 'source "$HOME/.rvm/scripts/rvm" && srd exec'
```

## Globally Installing Bundled Gems

Another option is to install the bundled gems to the global gemset:

```
$ bundle install --global
```

# Logging

Sifttter Redux logs a lot of good info to `~/.sifttter_redux_log`. It makes use
of Ruby's standard log levels:

* DEBUG
* INFO
* WARN
* ERROR
* FATAL
* UNKNOWN

If you want to see more or less in your log files, simply change the `log_level`
value in `~/.sifttter_redux` to your desired level.

# Bugs and Feature Requests

My current roadmap can be found on my
[Trello board](https://trello.com/b/z4vl3YxC/sifttter-redux "Sifttter Redux Trello Board").

To report bugs with or suggest features/changes for Sifttter Redux, please use
the [Issues Page](http://github.com/bachya/sifttter-redux/issues).

Contributions are welcome and encouraged. To contribute:

* [Fork Sifttter Redux](http://github.com/bachya/sifttter-redux/fork).
* Create a branch for your contribution (`git checkout -b new-feature`).
* Commit your changes (`git commit -am 'Added this new feature'`).
* Push to the branch (`git push origin new-feature`).
* Create a new [Pull Request](http://github.com/bachya/sifttter-redux/compare/).

# License

(The MIT License)

Copyright © 2014 Aaron Bach <bachya1208@gmail.com>

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the 'Software'), to deal in the
Software without restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the
Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# Credits

* Craig Eley for [Sifttter](http://craigeley.com/post/72565974459/sifttter-an-ifttt-to-day-one-logger "Sifttter")
and for giving me the idea for Sifttter Redux
* Dave Copeland for [GLI](https://github.com/davetron5000/gli "GLI")
* Andrea Fabrizi for [Dropbox Uploader](https://github.com/andreafabrizi/Dropbox-Uploader "Dropbox Uploader")
* ~~Tom Preston-Werner~~ (sorry: can't
support [harrassment](http://www.businessinsider.com/github-co-founder-suspended-2014-3 "GitHub Founder Tom Preston-Werner Suspended After Harassment Allegations"))
~~and~~ Lee Jarvis for [Chronic](https://github.com/mojombo/chronic "Chronic")
