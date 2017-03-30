#!/usr/bin/env ruby

#  encoding: UTF-8
#
# Evaluate free system memory from Linux based systems.
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
#   check-memory.rb -w warn_percent -c critical_percent
#
# LICENSE:
#   Copyright 2017 Alex Werle Baule <alexwbaule@gmail.com>
#   Released under the same terms as Sensu (the MIT license); see LICENSE
#   for details.

require 'sensu-plugin/check/cli'

class CheckMemory < Sensu::Plugin::Check::CLI
  option :warning,
         short: '-w warning',
         default: 0,
     proc: Proc.new { |w| w.to_i }

  option :critical,
         short: '-c critical',
         default: 0,
     proc: Proc.new { |c| c.to_i }



  def run
    mem = metrics_hash
    total_free = (( mem['free'] + mem['buffers'] + mem['cached'] ) / 1024.0 ).round(0)

    if total_free <= config[:critical]
    critical total_free.to_s + "MB"
    elsif total_free <= config[:warning]
    warning total_free.to_s + "MB"
    else
       ok total_free.to_s + "MB"
    end
  end

  def metrics_hash
    mem = {}

    meminfo_output.each_line do |line|
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
