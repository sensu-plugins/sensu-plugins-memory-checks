# Change Log
This project adheres to [Semantic Versioning](http://semver.org/).

This CHANGELOG follows the located [here](https://github.com/sensu-plugins/community/blob/master/HOW_WE_CHANGELOG.md)

## [Unreleased]

## [3.0.3] - 2017-09-23
### Fixed
- metrics-memory-percent.rb, metrics-memory.rb: change 'usedWOBuffersCaches' and 'freeWOBuffersCaches' calculation to use MemAvailable in /proc/meminfo when available. (@jpoizat)

### Added
- update CHANGELOG guidelines location (@majormoses)

## [3.0.2] - 2017-07-31
### Fixed
- check-memory-percent.rb, check-memory.rb: fix shell call response when running on non en_US locale systems (@stefan-walluhn)

## [3.0.1] - 2017-07-07
### Fixed
- check-memory.sh: fixed a syntax error preventing it from running (@majormoses)

### [3.0.0] - 2017-07-07
### Added
- ruby 2.4 testing (@majormoses)

### Fixed
- in PR template spell "compatibility" correctly (@majormoses)

### Breaking Changes
- `check-memory.sh`: Validate that both critical and warning values are provided. (@EslamElHusseiny)

## [2.1.0] - 2017-03-08
### Changed
- `check-ram-rb`: to better address Linux users expecting free ram to not include buffer cache we bumped to a new version of vmstat to get the new functionality. As this is not installed you must manually install `2.3.0`. This will use the field `MemAvailable` in `/proc/meminfo`. It maintains its backwards compatibility to keep existing behavior. (@majormoses)

## [2.0.0] - 2017-01-17
### Breaking Changes
- The hardcoded default thresholds of 90% warn 95% critical in `check-ram.rb` when using the `--used` option
  have been removed so custom thresholds can be passed. To obtain identical behavior configure the check
  like `check-ram.rb --used -w 90 -c 95`.
- Ruby < 2.1 is no longer supported

### Added
- `check-swap-percent.rb`: Add option `--required` to alert if swap is missing (@losisin)
- Support for Ruby 2.3.0 (@eheydrick)

### Fixed
- `check-memory-percent.sh`: Corrected units (from MB to %) in performance data output (@ttarczynski)
- `check-ram.rb`: fixed overwriting of cli args for warning and critical when using `--used` (@majormoses)
- `check-ram.rb`: Only require vmstat on `#run` (@PChambino)

### Changed
- `check-swap-percent.rb`: Rewrite the check for swap percentage in pure ruby while maintaining backwards compatibility. (@losisin)
- set environment varable LANG=C for reliable output parsing (@corro)

### Removed
- Support for Ruby < 2.1 (@eheydrick)
- `check-swap-percent.sh`: Remove obsolete shell script. (@losisin)

## [1.0.2] - 2016-04-12
### Fixed
- `check-memory.sh`: Update for Ubuntu 16.04 `free` output

## [1.0.1] - 2016-03-07
### Fixed
- `check-memory-percent.sh` returned "MEM UNKNOWN" when less than 1% of memory was free

## [1.0.0] - 2016-03-06
### Changed
- removed `vmstat` from a runtime dependency to remove gcc dependency.
- added documentation about how you would install the required runtime dependencies if you are using `bin/check-ram.rb`.
- added some checking to `bin/check-ram.rb` to be handled appropriately if you do not install the required dependencies.

## [0.0.9] - 2016-02-05
### Added
- new certs

## [0.0.8] - 2015-09-29
### Fixed
- check-ram.rb incorrectly calculated ram
- check-memory.sh, support for RHEL 7.

## [0.0.7] - 2015-08-11
### Fixed
- check-memory.sh, system may not have /etc/redhat-version

### Changed
- bump rubocop

## [0.0.6] - 2015-07-30
  - replaced `free` with vmstat gem to add more nix compatibility
  - added option free (default to keep old default behavior)
  - added option used to change check to checked used instead of memory free

## [0.0.5] - 2015-07-14
### Fixed
- fixed bad script filenames that prevented the checks for executing

## [0.0.4] - 2015-07-14
### Changed
- updated sensu-plugin gem to 1.2.0
- removal of all shell scripts in favor of ruby scripts
- Updated documentation links in the README and CONTRIBUTING
- set all deps to alpha order in Rakefile
- set all deps to alpha order in Gemspec
- removed unused tasks in Rakefile

## [0.0.3] - 2015-06-29
### Added
- Support for Fedora22 and Cent7 to `check-memory-pcnt.sh`
- Add wrapper for all shell scripts

## [0.0.2] - 2015-06-03
### Fixed
- added binstubs
### Changed
- removed cruft from /lib

## 0.0.1 - 2015-05-21
### Added
- initial release

[Unreleased]: https://github.com/sensu-plugins/sensu-plugins-memory-checks/compare/3.0.1...HEAD
[3.0.2]: https://github.com/sensu-plugins/sensu-plugins-memory-checks/compare/3.0.1...3.0.2
[3.0.1]: https://github.com/sensu-plugins/sensu-plugins-memory-checks/compare/https://github.com/sensu-plugins/sensu-plugins-memory-checks/compare/3.0.0...3.0.1
[3.0.0]: https://github.com/sensu-plugins/sensu-plugins-memory-checks/compare/2.1.0...3.0.0
[2.1.0]: https://github.com/sensu-plugins/sensu-plugins-memory-checks/compare/2.0.0...2.1.0
[2.0.0]: https://github.com/sensu-plugins/sensu-plugins-memory-checks/compare/1.0.2...2.0.0
[1.0.2]: https://github.com/sensu-plugins/sensu-plugins-memory-checks/compare/1.0.1...1.0.2
[1.0.1]: https://github.com/sensu-plugins/sensu-plugins-memory-checks/compare/1.0.0...1.0.1
[1.0.0]: https://github.com/sensu-plugins/sensu-plugins-memory-checks/compare/0.0.9...1.0.0
[0.0.9]: https://github.com/sensu-plugins/sensu-plugins-memory-checks/compare/0.0.8...0.0.9
[0.0.8]: https://github.com/sensu-plugins/sensu-plugins-memory-checks/compare/0.0.7...0.0.8
[0.0.7]: https://github.com/sensu-plugins/sensu-plugins-memory-checks/compare/0.0.6...0.0.7
[0.0.6]: https://github.com/sensu-plugins/sensu-plugins-memory-checks/compare/0.0.5...0.0.6
[0.0.5]: https://github.com/sensu-plugins/sensu-plugins-memory-checks/compare/0.0.4...0.0.5
[0.0.4]: https://github.com/sensu-plugins/sensu-plugins-memory-checks/compare/0.0.3...0.0.4
[0.0.3]: https://github.com/sensu-plugins/sensu-plugins-memory-checks/compare/0.0.2...0.0.3
[0.0.2]: https://github.com/sensu-plugins/sensu-plugins-memory-checks/compare/0.0.1...0.0.2
