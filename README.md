[![Sensu Bonsai Asset](https://img.shields.io/badge/Bonsai-Download%20Me-brightgreen.svg?colorB=89C967&logo=sensu)](https://bonsai.sensu.io/assets/sensu-plugins/sensu-plugins-memory-checks)
[![Build Status](https://travis-ci.org/sensu-plugins/sensu-plugins-memory-checks.svg?branch=master)](https://travis-ci.org/sensu-plugins/sensu-plugins-memory-checks)
[![Gem Version](https://badge.fury.io/rb/sensu-plugins-memory-checks.svg)](http://badge.fury.io/rb/sensu-plugins-memory-checks)
[![Code Climate](https://codeclimate.com/github/sensu-plugins/sensu-plugins-memory-checks/badges/gpa.svg)](https://codeclimate.com/github/sensu-plugins/sensu-plugins-memory-checks)
[![Test Coverage](https://codeclimate.com/github/sensu-plugins/sensu-plugins-memory-checks/badges/coverage.svg)](https://codeclimate.com/github/sensu-plugins/sensu-plugins-memory-checks)
[![Dependency Status](https://gemnasium.com/sensu-plugins/sensu-plugins-memory-checks.svg)](https://gemnasium.com/sensu-plugins/sensu-plugins-memory-checks)

## Sensu Memory Check Plugin

- [Overview](#overview)
- [Files](#files)
- [Usage examples](#usage-examples)
- [Configuration](#configuration)
  - [Sensu Go](#sensu-go)
    - [Asset registration](#asset-registration)
    - [Asset definition](#asset-definition)
    - [Check definition](#check-definition)
  - [Sensu Core](#sensu-core)
    - [Check definition](#check-definition)
- [Installation from source](#installation-from-source)
- [Additional notes](#additional-notes)
- [Contributing](#contributing)

### Overview


This plugin provides native memory instrumentation for monitoring and metrics collection, including memory usage via `free` and `vmstat`, including metrics. **NOTE**: This plugin may have cross-platform issues.

### Files
 * bin/check-memory.rb
 * bin/check-memory.sh
 * bin/check-memory-percent.rb
 * bin/check-memory-percent.sh
 * bin/check-ram.rb
 * bin/check-swap-percent.rb
 * bin/check-swap.sh
 * bin/check-swap.rb
 * bin/metrics-memory-percent.rb
 * bin/metrics-memory.rb
 
**check-memory**
Evaluate free system memory for Linux-based systems.

**check-memory-percent**
Evaluate the percentage of free system memory for Linux-based systems.

**check-ram**
Check the percentage of free RAM.

**check-swap-percent**
Checks swap usage as a percentage of the total swap.

**check-swap**
Evaluate swap memory usage for Linux-based systems.

**metrics-memory-percent**
Read memory statistics as a percentage and put them in a form usable by Graphite. Metrics borrowed from [HoardD](https://github.com/coredump/hoardd).

**metrics-memory-vmstat**
Read memory statistics and put them in a form usable by `vmstat`.

**metrics-memory**
Read memory statistics and put them in a form usable by Graphite. Metrics borrowed from [HoardD](https://github.com/coredump/hoardd).

## Usage examples

### Help

**check-ram.rb**
```
Usage: /opt/sensu/embedded/bin/check-ram.rb (options)
    -c CRIT
    -f, --free                       checks free threshold, defaults to true
    -m, --megabytes                  Unless --megabytes is specified the thresholds are in percentage of memory used as opposed to MB of ram left
    -u, --used                       checks used threshold, defaults to false
    -w WARN
```

**metrics-memory-percent.rb**
```
Usage: /opt/sensu/embedded/bin/metrics-memory-percent.rb (options)
    -s, --scheme SCHEME              Metric naming scheme, text to prepend to metric
```

## Configuration
### Sensu Go
#### Asset registration

Assets are the best way to make use of this plugin. If you're not using an asset, please consider doing so! If you're using sensuctl 5.13 or later, you can use the following command to add the asset: 

`sensuctl asset add sensu-plugins/sensu-plugins-memory-checks`

If you're using an earlier version of sensuctl, you can download the asset definition from [this project's Bonsai Asset Index page](https://bonsai.sensu.io/assets/sensu-plugins/sensu-plugins-memory-checks).

#### Asset definition

```yaml
---
type: Asset
api_version: core/v2
metadata:
  name: sensu-plugins-memory-checks
spec:
  url: https://assets.bonsai.sensu.io/c5391d4ae186484226732344b35cf95c0b07b8ec/sensu-plugins-memory-checks_4.0.0_centos_linux_amd64.tar.gz
  sha512: ea297a85aa3612da7f78d948f9784443fffac511040c5130a2dcde7191a0004044c2ef881e665520cbc64431955ab19920d84de6b5fed85c63da7091c4b93bf0
```

#### Check definition

```yaml
---
type: CheckConfig
spec:
  command: "check-memory.rb"
  handlers: []
  high_flap_threshold: 0
  interval: 10
  low_flap_threshold: 0
  publish: true
  runtime_assets:
  - sensu-plugins/sensu-plugins-memory-checks
  - sensu/sensu-ruby-runtime
  subscriptions:
  - linux
```

### Sensu Core

#### Check definition
```json
{
  "checks": {
    "metrics-disk-usage": {
      "command": "metric-disk-usage.rb",
      "subscribers": ["linux"],
      "interval": 10,
      "refresh": 10,
      "handlers": ["influxdb"]
    }
  }
}
```

## Installation from source

### Sensu Go

See the instructions above for [asset registration](#asset-registration)

### Sensu Core

Install and setup plugins on [Sensu Core](https://docs.sensu.io/sensu-core/latest/installation/installing-plugins/)

## Additional notes

### `bin/check-ram.rb`

Ruby does not have a good native way to grab information on memory usage (without using C extensions or running shell commands and parsing out). For this reason, `check-ram.rb` uses a gem called `vmstat` that has a dependency on a GCC to compile the C extensions.

To avoid errors that occur when trying to compile the C extensions without GCC present, we do not install the `vmstat` gem by default.

**Users who need to use `check-ram.rb` must install build tools, including GCC**. This usually requires two steps but can vary based on your distribution and Ruby setup:

1. Install `gcc`. If you are on a Debian system, GCC is located in the `build-essential` package. On RHEL systems, `yum groupinstall "Development tools" ` will provide the required packages.
2. Install the `vmstat` gem into the path from which Sensu gems are expected to run, `sudo /opt/sensu/embedded/bin/gem install vmstat --no-rdoc --no-ri`, or the equivalent for installing Sensu gems in your configuration management system.

### Certification verification

If you are verifying certificates in the gem install you will need the [certificate for the `sys-filesystem` gem](https://raw.githubusercontent.com/djberg96/sys-filesystem/ffi/certs/djberg96_pub.pem) loaded in the gem certificate store.

## Contributing

See [CONTRIBUTING.md](https://github.com/sensu-plugins/sensu-plugins-memory-checks/blob/master/CONTRIBUTING.md) for information about contributing to this plugin.
