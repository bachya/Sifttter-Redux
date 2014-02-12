Sifttter Redux
==============

Siftter Redux is a modification of Craig Eley's [Siftter](http://gist.github.com/craigeley/8301817 "Siftter"), a script to collect information from [IFTTT](http://www.ifttt.com "IFTTT") and place it in a [Day One](http://dayoneapp.com, "Day One") journal. 

Siftter Redux's primary difference is in its execution method: it intended to run autonomously so that it does not need to be manually activated. This allows IFTTT data to be synchronized to Day One on a schedule.

The aim of this project was to use a Raspberry Pi; as such, the instructions below are specifically catered to that platform. That said, it should be possible to install and configure on any *NIX platform.

## Prerequisites

There are three prerequisites needed to run Sifttter Redux:

* Ruby (version 1.9.3 or greater)
* Git
* UUID

These packages must be installed on your system before running Sifttter Redux. To install these packages on Raspbian:

```
sudo apt-get install ruby
sudo apt-get install git-core
sudo apt-get install uuid
```

## Installation

First, clone this repository via git:

```
git clone https://github.com/bachya/Sifttter-Redux.git
```

Next, cd into the Sifttter Redux directory and install the necessary gems:

```
cd Sifttter-Redux
bundle install
```

*(note that you may want to run `bundle install --global` for the sake of `cron` -- [see below](#cron-job))*

Finally, make sure the script is executable and initialize it:

```
chmod +x srd
./srd init
```

## Usage

Syntax and usage can be accessed by running `./srd help`:

```
NAME
    srd - Sifttter Redux v1.1

    A modification of Craig Eley's Sifttter that allows for smart
    installation on a standalone *NIX device (such as a Raspberry Pi).

SYNOPSIS
    srd [global options] command [command options] [arguments...]

GLOBAL OPTIONS
    --help - Show this message

COMMANDS
    exec - Execute the script
    help - Shows a list of commands or help for one command
    init - Install and initialize dependencies
```

## "Catch-up" Mode

Sometimes, events occur that prevent Sifttter Redux from running (power loss to your device, a bad Cron job, etc.). In this case, Sifttter Redux's "catch-up" mode can be used to collect any valid journal data between a range of dates.

To use this mode, simply specify `--from` and `--to` parameters when executing the script:

```
# Looks for entries from 2/1/2014 to 2/12/2014
./srd exec --from=2014-02-01 --to=2014-02-12
```

Even more simply, to create entries from a specific point until yesterday ("yesterday" because you might not be ready to have today's entries scanned):

```
# Looks for entries from 2/1/2014 to yesterday's date
./srd exec --from=2014-02-01
```

Two notes to be aware of:

* `--from` and `--to` are *inclusive* parameters, meaning that those dates will be included when searching for Siftter data.
* Although you can specify `--from` by itself, you cannot specify `--to` by itself.

Sifttter Redux makes use of the excellent [Chronic gem](https://github.com/mojombo/chronic "Chronic"), which provides natural language parsing for dates and times. This means that you can run commands with more "human" dates:

```
./srd exec --from="last Thursday" --to="yesterday"
```

See [Chronic's Examples section](https://github.com/mojombo/chronic#examples "Chronic Examples") for more examples.

## Cron Job

By installing an entry to the Raspberry Pi's `crontab`, Sifttter Redux can be run automatically on a schedule.

One issue that arises is the loading of the bundled gems; because `cron` runs in a limited environment, it does not automatically know where to find installed gems.

### Using RVM

If your Raspberry Pi uses RVM, this `crontab` entry will do:

```
55 23 * * * /bin/bash -l -c 'source "$HOME/.rvm/scripts/rvm" && "$HOME/Sifttter-Redux/srd" exec'
```

### Globally Installing Bundled Gems

Another option is to install the bundled gems to the global gemset:

```
bundle install --global
```

## Known Issues

None at the moment.

## Future Releases

Some functionality I would like to tackle for future releases:

* Interactive cron job installer
* Verbose mode
* Automatic gem bundling

## Bugs and Feature Requests

To report bugs with or suggest features/changes for Sifttter Redux, please use the [Issues Page](http://github.com/bachya/Sifttter-Redux/issues).

Contributions are welcome and encouraged. To contribute:

* [Fork Sifttter Redux](http://github.com/bachya/Sifttter-Redux/fork).
* Create a branch for your contribution (`git checkout -b new-feature`).
* Commit your changes (`git commit -am 'Added this new feature'`).
* Push to the branch (`git push origin new-feature`).
* Create a new [Pull Request](http://github.com/bachya/Sifttter-Redux/compare/).

## License

(The MIT License)

Copyright © 2014 Aaron Bach <bachya1208@gmail.com>

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the 'Software'), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

## Credits

* Craig Eley for Sifttter and for giving me the idea for Sifttter Redux
* Andrea Fabrizi for her stellar Dropbox Uploader project
* The Chronic folks for making the aforementioned wonderful Chronic gem