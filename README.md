## Sensu-Plugins-memory-checks

[![Build Status](https://travis-ci.org/sensu-plugins/sensu-plugins-memory-checks.svg?branch=master)](https://travis-ci.org/sensu-plugins/sensu-plugins-memory-checks)
[![Gem Version](https://badge.fury.io/rb/sensu-plugins-memory-checks.svg)](http://badge.fury.io/rb/sensu-plugins-memory-checks)
[![Code Climate](https://codeclimate.com/github/sensu-plugins/sensu-plugins-memory-checks/badges/gpa.svg)](https://codeclimate.com/github/sensu-plugins/sensu-plugins-memory-checks)
[![Test Coverage](https://codeclimate.com/github/sensu-plugins/sensu-plugins-memory-checks/badges/coverage.svg)](https://codeclimate.com/github/sensu-plugins/sensu-plugins-memory-checks)
[![Dependency Status](https://gemnasium.com/sensu-plugins/sensu-plugins-memory-checks.svg)](https://gemnasium.com/sensu-plugins/sensu-plugins-memory-checks)

## Functionality

## Files
 * bin/check-memory.rb
 * bin/check-memory.sh
 * bin/check-memory-percent.rb
 * bin/check-memory-percent.sh
 * bin/check-ram.rb
 * bin/check-swap-percent.rb
 * bin/check-swap-percent.sh
 * bin/check-swap.sh
 * bin/check-swap.rb
 * bin/metrics-memory-percent.rb
 * bin/metrics-memory.rb

## Usage

## Installation

[Installation and Setup](http://sensu-plugins.io/docs/installation_instructions.html)

### `bin/check-ram.rb`

Ruby does not have a good native way without the use of C extensions to grab information on memory usage (outside of running shell commands and parsing out). Because of this `check-ram.rb` uses a gem called `vmstat` which has a somewhat annoying dependency on a gcc to compile the C extensions. In order to not force people to install gcc if they are not using `check-ram.rb` we do not install it by default, and is up to the user to make sure that they install it. This requires two steps and can vary based on your distribution and ruby set up:
  *  Install `gcc`. If you are on a debian based system it is located in the `build-essential` package.
  * Install `vmstat` gem into the path that sensu gems are expected to run from:
    * `/opt/sensu/embedded/bin/gem install vmstat --no-rdoc --no-ri` or the equivalent for installing sensu gems in your configuration management system

## Notes
