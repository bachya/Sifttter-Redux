Sifttter Redux
==============

Siftter Redux is a modification of Craig Eley's [Siftter](http://gist.github.com/craigeley/8301817 "Siftter"), a script to collect information from [IFTTT](http://www.ifttt.com "IFTTT") and place it in a [Day One](http://dayoneapp.com, "Day One") journal. Siftter Redux it intended to run autonomously on a *NIX-based device, such as a Raspberry Pi, so that it does not need to be manually activated.

## Installation

First, clone this repository via git:

```
git clone https://github.com/bachya/Sifttter-Redux.git
```

...or, if you'd rather forego git, you can download the script by itself:

```
curl "https://raw2.github.com/bachya/Sifttter-Redux/master/srd" -o srd
```

Basic Steps:
- clone
- bundle install
- sudo apt-get install uuid
- sudo apt-get install ack-grep