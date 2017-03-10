#! /usr/bin/env ruby
#  encoding: UTF-8
#
# Checks SWAP usage as a % of the total swap
#
# Date: 2016-11-21
# Author: Aleksandar Stojanov <aleksandar.stojanov@polarcape.com>
#
# PLATFORMS:
#   Linux
#
# DEPENDENCIES:
#   gem: sensu-plugin
#   commands: free, grep
#
# USAGE:
#   check-swap-percent.rb -w warn_percent -c critical_percent
#
# LICENSE:
#   Copyright 2016 Aleksandar Stojanov <aleksandar.stojanov@polarcape.com>
#   Released under the same terms as Sensu (the MIT license); see LICENSE
#   for details.

require 'sensu-plugin/check/cli'

class CheckSWAP < Sensu::Plugin::Check::CLI
  option :warn,
         short: '-w WARNING',
         long: '--warning',
         proc: proc(&:to_i),
         default: 70

  option :critical,
         short: '-c CRITICAL',
         long: '--critical',
         proc: proc(&:to_i),
         default: 80

  option :megabytes,
         short: '-m',
         long: '--megabytes',
         description: 'alert on mbs rather than %, defaults to false',
         boolean: true,
         default: false

  option :required,
         short: '-r',
         long: '--required',
         description: 'checks if swap is missing from the machine',
         boolean: true,
         default: false

  def get_swaps
    swaps = {}
    begin
      File.open("/proc/swaps", "r") do |f|
        f.each_with_index do |line, index|
          if index == 0
            $fields = line.squeeze(' ').gsub("\t", ' ').split(' ')
          else
            # p index
            key = line.split(' ')[0]
            swaps[key] = {}
            data = line.squeeze(' ').gsub("\t", ' ').split(' ') # unless index == 0
            $fields.each_with_index do |f,i|
              # p "fields: #{f},#{data[i]}"
              swaps[key][f] = data[i]
            end
          end
        end
      end
    rescue Errno::ENOENT
      unknown 'Unable to find /proc/swaps please report a bug with information about your OS'
    end
    swaps
  end

  def get_percent(used, size)
    (100 * (used.to_i / size.to_f)).round(2)
  end

  def bytes_to_mbs(value)
    (value /= 1024 * 1024)
  end

  def run
    # Get output from free command
    # output_swap = `free -m | grep "Swap"`
    crits = []
    warns = []
    swaps = get_swaps
    if swaps.empty?
      if config[:required]
        critical 'ERROR: you said I should fail if swap is not present!'
      else
        unknown 'Unable to find swaps...bug?'
      end
    end
    swaps.each do |o,k|
      used_swap = k['Used']
      total_swap = k['Size']
      if config[:megabytes]
        mbs = bytes_to_mbs(used_swap.to_f)
        # crits << get_percent(k['Used'], k['Size'])
        crits << "#{o}: #{mbs}" if mbs >= config[:warn]
        warns << "#{o}: #{mbs}" if mbs >= config[:warning]
      else
        # we must want percentages
        percent = get_percent(used_swap, total_swap)
        crits << "#{o}: #{percent}" if percent >= config[:critical]
        warns << "#{o}: #{percent}" if percent >= config[:warn]
      end
    end

    # alert, or not?
    if crits.any?
      critical "swap limits exceded critical thresholds: #{crits}"
    elsif warns.any?
      warning "swap limits exceded warning thresholds: #{warns}"
    else
      ok 'all swaps are within expected thresholds'
    end
  end
end
