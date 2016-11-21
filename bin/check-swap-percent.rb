#! /usr/bin/env ruby
#  encoding: UTF-8
#
# Checks SWAP usage as a % of the total swap
#
# Date: 2016-11-21
# Author: Aleksandar Stojanov <aleksandar.stojanov@polarcape.com>
#
# PLATFORMS:
#   Linux, BSD
#
# DEPENDENCIES:
#   gem: sensu-plugin
#
# USAGE:
#   check-swap-percent.rb -w warn_percent -c critical_percent
#
# Uses: free & grep
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

  def run
    # Get output from free command
    output_swap = `free -m | grep "Swap"`

    # Prepare total and used swap
    total_swap = output_swap.split(' ')[1].to_i
    used_swap = output_swap.split(' ')[2].to_i

    # Prepare output message
    output = "#{used_swap}/#{total_swap}"

    # Calculate round percent from used and total
    swapp = (100.0 * (used_swap.nonzero? || 1) / total_swap).round(0)

    # Check conditions from config
    if swapp >= config[:critical]
      critical "#{swapp}% ; #{output}\n"
    elsif swapp >= config[:warn]
      warning "#{swapp}% ; #{output}\n"
    else
      ok "#{swapp}% ; #{output}\n"
    end
  end
end