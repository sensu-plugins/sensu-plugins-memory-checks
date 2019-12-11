#! /usr/bin/env ruby
# frozen_string_literal: true

#   metrics-memory-percent
#
# DESCRIPTION:
#
# OUTPUT:
#   metric data
#
# PLATFORMS:
#   Linux
#
# DEPENDENCIES:
#   gem: sensu-plugin
#
# USAGE:
#  ./metrics-memory-percent.rb
#
# LICENSE:
#   Copyright 2012 Sonian, Inc <chefs@sonian.net>
#   Released under the same terms as Sensu (the MIT license); see LICENSE
#   for details.
#

require 'sensu-plugin/metric/cli'
require 'socket'

class MemoryGraphite < Sensu::Plugin::Metric::CLI::Graphite
  option :scheme,
         description: 'Metric naming scheme, text to prepend to metric',
         short: '-s SCHEME',
         long: '--scheme SCHEME',
         default: "#{Socket.gethostname}.memory_percent"

  def run
    # Based on memory-metrics.rb

    # Metrics borrowed from hoardd: https://github.com/coredump/hoardd

    mem = metrics_hash

    mem.each do |k, v|
      output "#{config[:scheme]}.#{k}", v
    end

    ok
  end

  def metrics_hash
    mem = {}
    memp = {}

    meminfo_output.each_line do |line|
      mem['total']     = line.split(/\s+/)[1].to_i * 1024 if line =~ /^MemTotal/
      mem['free']      = line.split(/\s+/)[1].to_i * 1024 if line =~ /^MemFree/
      mem['buffers']   = line.split(/\s+/)[1].to_i * 1024 if line =~ /^Buffers/
      mem['cached']    = line.split(/\s+/)[1].to_i * 1024 if line =~ /^Cached/
      mem['swapTotal'] = line.split(/\s+/)[1].to_i * 1024 if line =~ /^SwapTotal/
      mem['swapFree']  = line.split(/\s+/)[1].to_i * 1024 if line =~ /^SwapFree/
      mem['dirty']     = line.split(/\s+/)[1].to_i * 1024 if line =~ /^Dirty/
      mem['available'] = line.split(/\s+/)[1].to_i * 1024 if line =~ /^MemAvailable/
    end

    mem['swapUsed'] = mem['swapTotal'] - mem['swapFree']
    mem['used'] = mem['total'] - mem['free']

    # if MemAvailable exist, use it to calculate "available memory"
    if mem.key?('available')
      mem['usedWOBuffersCaches'] = mem['total'] - mem['available']
      mem['freeWOBuffersCaches'] = mem['available']
    else
      mem['usedWOBuffersCaches'] = mem['used'] - (mem['buffers'] + mem['cached'])
      mem['freeWOBuffersCaches'] = mem['free'] + (mem['buffers'] + mem['cached'])
    end
    # to prevent division by zero
    swptot = if mem['swapTotal'].zero?
               1
             else
               mem['swapTotal']
             end

    mem.each_key do |k|
      # with percentages, used and free are exactly complementary
      # no need to have both
      # the one to drop here is "used" because "free" will
      # stack up neatly to 100% with all the others (except swapUsed)
      # #YELLOW
      memp[k] = 100.0 * mem[k] / mem['total'] if k != 'total' && k !~ /swap/ && k != 'used'

      # with percentages, swapUsed and swapFree are exactly complementary
      # no need to have both
      memp[k] = 100.0 * mem[k] / swptot if k != 'swapTotal' && k =~ /swap/ && k != 'swapFree'
    end

    memp
  end

  def meminfo_output
    File.open('/proc/meminfo', 'r')
  end
end
