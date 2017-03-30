#!/usr/bin/env ruby

#  encoding: UTF-8
#
# Checks Memory usage as a % of the total Memory
#
# Date: 2017-03-30
# Author: Alex Werle Baule <alexwbaule@gmail.com>
#
# PLATFORMS:
#   Linux
#
# DEPENDENCIES:
#   gem: sensu-plugin
#
# USAGE:
#   check-memory-percent.rb -w warn_percent -c critical_percent
#
# LICENSE:
#   Copyright 2017 Alex Werle Baule <alexwbaule@gmail.com>
#   Released under the same terms as Sensu (the MIT license); see LICENSE
#   for details.

require 'sensu-plugin/check/cli'

class CheckMemoryPercent < Sensu::Plugin::Check::CLI
  option :warning,
         short: '-w warning',
         default: 80,
	 proc: Proc.new { |w| w.to_i }

  option :critical,
         short: '-c critical',
         default: 90,
	 proc: Proc.new { |c| c.to_i }


  def run
    mem = metrics_hash
    total_free = mem['free'] + mem['buffers'] + mem['cached']
    total_used = mem['total'] - total_free
    percent = (( total_used.to_f / mem['total'].to_f ) * 100).round(2)

    if percent >= config[:critical]
	critical percent.to_s + "%"
    elsif percent >= config[:warning]
	warning percent.to_s + "%"
    else
       ok percent.to_s + "%"
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
