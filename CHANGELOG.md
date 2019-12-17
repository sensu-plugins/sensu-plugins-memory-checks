# Change Log
This project adheres to [Semantic Versioning](http://semver.org/).

This CHANGELOG follows the located [here](https://github.com/sensu-plugins/community/blob/master/HOW_WE_CHANGELOG.md)

## [Unreleased]

## [4.1.1] - 2019-12-17
### Fixed
- Quick fix for asset generation, removing centos build from bonsai.yml

## [4.1.0] - 2019-12-16
### Changed
- Updated asset build target to support Centos6
- Updated rake development requirement from ~> 10.5 to ~> 13.0 .
- Updated rubocop development requirement from ~> 0.51.0 to ~> 0.77.0 .
- Updated bundler development requirement from ~> 1.7 to ~> 2.0 .
- Updated README

## [4.0.0] - 2019-04-18
### Breaking Changes
- Update minimum required ruby version to 2.3. Drop unsupported ruby versions.
- Bump `sensu-plugin` dependency from `~> 1.2` to `~> 4.0` you can read the changelog entries for [4.0](https://github.com/sensu-plugins/sensu-plugin/blob/master/CHANGELOG.md#400---2018-02-17), [3.0](https://github.com/sensu-plugins/sensu-plugin/blob/master/CHANGELOG.md#300---2018-12-04), and [2.0](https://github.com/sensu-plugins/sensu-plugin/blob/master/CHANGELOG.md#v200---2017-03-29)

### Added
- Travis build automation to generate Sensu Asset tarballs that can be used n conjunction with Sensu provided ruby runtime assets and the Bonsai Asset Index
- Require latest sensu-plugin for [Sensu Go support](https://github.com/sensu-plugins/sensu-plugin#sensu-go-enablement)


## [3.2.0] - 2018-04-17
### Added
- Added metrics-memory-vmstat.rb (@yuri-zubov sponsored by Actility, https://www.actility.com)

## [3.1.3] - 2018-03-27
### Security
- updated yard dependency to `~> 0.9.11` per: https://nvd.nist.gov/vuln/detail/CVE-2017-17042 (@majormoses)

## [3.1.2] - 2018-03-07
### Security
- updated rubocop dependency to `~> 0.51.0` per: https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-8418. (@majormoses)

### Changed
- appeased the cops (@majormoses)

## [3.1.1] - 2017-10-25
### Fixed
- check-memory-percent.sh: compare variable `$os` rather than the string 'os' (@lcc207)

## [3.1.0] - 2017-10-20
### Added
- check-memory-percent.sh: added osx support (@jjdiazgarcia)
- check-memory-percent.sh: make if statement syntax consistent with the script (@majormoses)

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

[Unreleased]: https://github.com/sensu-plugins/sensu-plugins-memory-checks/compare/4.1.1...HEAD
[4.1.1]: https://github.com/sensu-plugins/sensu-plugins-memory-checks/compare/4.1.0..4.1.1
[4.1.0]: https://github.com/sensu-plugins/sensu-plugins-memory-checks/compare/4.0.0..4.1.0
[4.0.0]: https://github.com/sensu-plugins/sensu-plugins-memory-checks/compare/3.2.0..4.0.0
[3.2.0]: https://github.com/sensu-plugins/sensu-plugins-memory-checks/compare/3.1.3..3.2.0
[3.1.3]: https://github.com/sensu-plugins/sensu-plugins-memory-checks/compare/3.1.2...3.1.3
[3.1.2]: https://github.com/sensu-plugins/sensu-plugins-memory-checks/compare/3.1.1...3.1.2
[3.1.1]: https://github.com/sensu-plugins/sensu-plugins-memory-checks/compare/3.1.0...3.1.1
[3.1.0]: https://github.com/sensu-plugins/sensu-plugins-memory-checks/compare/3.0.1...3.1.0
[3.0.2]: https://github.com/sensu-plugins/sensu-plugins-memory-checks/compare/3.0.1...3.0.2
[3.0.1]: https://github.com/sensu-plugins/sensu-plugins-memory-checks/compare/3.0.0...3.0.1
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
