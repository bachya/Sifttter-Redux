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

Finally, make sure the script is executable and initialize it:

```
chmod +x srd
./srd init
```

## Usage

Syntax and usage can be accessed by running `./srd help`:

```
NAME
    srd - Sifttter Redux v0.1

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