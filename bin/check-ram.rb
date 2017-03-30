#! /usr/bin/env ruby
#  encoding: UTF-8
#
#   check-ram
#
# DESCRIPTION:
#
# OUTPUT:
#   plain text
#
# PLATFORMS:
#   Linux
#
# DEPENDENCIES:
#   gem: sensu-plugin
#
# USAGE:
#   check-ram.rb --help
#
# LICENSE:
#   Copyright 2012 Sonian, Inc <chefs@sonian.net>
#   Released under the same terms as Sensu (the MIT license); see LICENSE
#   for details.
#
# DATE: 2017-03-30
# Modified: Alex Werle Baule <alexwbaule@gmail.com>
# Removed the vmstat gem and gcc dependency 
# by reading the variables directly from /proc/meminfo

require 'sensu-plugin/check/cli'

class CheckRAM < Sensu::Plugin::Check::CLI
  option :megabytes,
         short: '-m',
         long: '--megabytes',
         description: 'Unless --megabytes is specified the thresholds are in percentage of memory used as opposed to MB of ram left',
         boolean: true,
         default: false

  option :free,
         short: '-f',
         long: '--free',
         description: 'checks free threshold, defaults to true',
         boolean: true,
         default: true

  option :used,
         short: '-u',
         long: '--used',
         description: 'checks used threshold, defaults to false',
         boolean: true,
         default: false

  option :warn,
         short: '-w WARN',
         proc: proc(&:to_i),
         default: 10

  option :crit,
         short: '-c CRIT',
         proc: proc(&:to_i),
         default: 5

  def run
    mem = metrics_hash
    free_ram = mem['free'] + mem['buffers'] + mem['cached']
    used_ram = mem['total'] - free_ram
	total_ram = mem['total']

    # only free or used should be defined, change defaults to mirror free
    if config[:used]
      config[:free] = false
    end

    if config[:megabytes]
      # free_ram is returned in Bytes. see: https://github.com/threez/ruby-vmstat/blob/master/lib/vmstat/memory.rb
      free_ram /= 1024 * 1024
      used_ram /= 1024 * 1024
      total_ram /= 1024 * 1024
      if config[:free]
        ram = free_ram
        message "#{ram} megabytes of RAM left"
      # return used ram
      elsif config[:used]
        ram = used_ram
        message "#{ram} megabytes of RAM used"
      end
    # use percentages
    else
      unknown 'invalid percentage' if config[:crit] > 100 || config[:warn] > 100

      if config[:free]
        ram = (free_ram / total_ram.to_f * 100).round(2)
        message "#{ram}% RAM free"
      elsif config[:used]
        ram = (used_ram / total_ram.to_f * 100).round(2)
        message "#{ram}% RAM used"
      end
    end
    # determine state
    if config[:free]
      critical if ram <= config[:crit]
      warning if ram <= config[:warn]
      ok
    elsif config[:used]
      critical if ram >= config[:crit]
      warning if ram >= config[:warn]
      ok
    end
  end

  def metrics_hash
    mem = {}

    meminfo_output.each_line do |line|
      mem['total']     = line.split(/\s+/)[1].to_i if line =~ /^MemTotal/
      mem['free']      = line.split(/\s+/)[1].to_i if line =~ /^MemFree/
      mem['buffers']   = line.split(/\s+/)[1].to_i if line =~ /^Buffers/
      mem['cached']    = line.split(/\s+/)[1].to_i if line =~ /^Cached/
    end
    mem
  end

  def meminfo_output
    File.open('/proc/meminfo', 'r')
  end

end
