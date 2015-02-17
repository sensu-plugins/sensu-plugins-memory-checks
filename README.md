## Sensu-Plugins-memory-checks

[![Build Status](https://travis-ci.org/sensu-plugins/sensu-plugins-memory-checks.svg?branch=master)](https://travis-ci.org/sensu-plugins/sensu-plugins-memory-checks)
[![Gem Version](https://badge.fury.io/rb/sensu-plugins-memory-checks.svg)](http://badge.fury.io/rb/sensu-plugins-memory-checks)
[![Code Climate](https://codeclimate.com/github/sensu-plugins/sensu-plugins-memory-checks/badges/gpa.svg)](https://codeclimate.com/github/sensu-plugins/sensu-plugins-memory-checks)
[![Test Coverage](https://codeclimate.com/github/sensu-plugins/sensu-plugins-memory-checks/badges/coverage.svg)](https://codeclimate.com/github/sensu-plugins/sensu-plugins-memory-checks)
[![Dependency Status](https://gemnasium.com/sensu-plugins/sensu-plugins-memory-checks.svg)](https://gemnasium.com/sensu-plugins/sensu-plugins-memory-checks)

## Functionality

## Files
 * bin/check-mem.sh
 * bin/check-memory-pcnt.sh
 * bin/check-ram
 * bin/check-swap-percentage.sh
 * bin/check-swap
 * bin/metrics-memory-percent
 * bin/metrics-memory

## Usage

## Installation

Add the public key (if you haven’t already) as a trusted certificate

```
gem cert --add <(curl -Ls https://raw.githubusercontent.com/sensu-plugins/sensu-plugins.github.io/master/certs/sensu-plugins.pem)
gem install sensu-plugins-memory-checks -P MediumSecurity
```

You can also download the key from /certs/ within each repository.

#### Rubygems

`gem install sensu-plugins-memory-checks`

#### Bundler

Add *sensu-plugins-disk-checks* to your Gemfile and run `bundle install` or `bundle update`

#### Chef

Using the Sensu **sensu_gem** LWRP
```
sensu_gem 'sensu-plugins-memory-checks' do
  options('--prerelease')
  version '0.0.1'
end
```

Using the Chef **gem_package** resource
```
gem_package 'sensu-plugins-memory-checks' do
  options('--prerelease')
  version '0.0.1'
end
```

## Notes
