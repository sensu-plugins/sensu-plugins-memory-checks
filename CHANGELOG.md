#Change Log
This project adheres to [Semantic Versioning](http://semver.org/).

This CHANGELOG follows the format listed at [Keep A Changelog](http://keepachangelog.com/)

## [Unreleased]

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

[unreleased]: https://github.com/sensu-plugins/sensu-plugins-memory-checks/compare/1.0.1...HEAD
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
