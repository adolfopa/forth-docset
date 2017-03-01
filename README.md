[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

# Forth Standard (2012) DocSet

Generate a [Dash](http://kapeli.com/dash/) docset with the [Forth 2012
Standard](http://forth-standard.org/).

## Usage and Installation

You can download the docset from
the [releases](https://github.com/adolfopa/forth-docset/releases)
section.

If for whatever reason you need to generate the docset from scratch,
clone this repo and execute `make`:

```sh
$ git clone git@github.com:adolfopa/forth-docset.git
$ cd forth-docset
$ make
```

If everything goes well, you will find the docset inside the `build/`
directory. To create a distributable tarball, use `make dist`.

## Requirements

In addition to the usual POSIX tools, you need the following in order
to build the docSet:

- Wget 1.18
- SQLite 3.8.10.2

Other versions of these tools may work as well.
