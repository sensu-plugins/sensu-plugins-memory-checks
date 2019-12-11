#! /usr/bin/env ruby
# frozen_string_literal: true

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
#   gem: vmstat
#   compiler: gcc
#
# USAGE:
#   check-ram.rb --help
#
# EXTRA INSTALL INSTRUCTIONS:
#   You must install gcc. This is needed to compile the vmstat gem
#   which you must put in a path that sensu can reach. See the README for
#   more details.
# NOTES:
#   The default behavior is to check % of RAM free. This can easily
#   be overwritten via args please see `check-ram.rb --help` for details
#   on each option.
#
# LICENSE:
#   Copyright 2012 Sonian, Inc <chefs@sonian.net>
#   Released under the same terms as Sensu (the MIT license); see LICENSE
#   for details.
#

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
    begin
      require 'vmstat'
    rescue LoadError => e
      raise unless e.message =~ /vmstat/

      unknown "Error unable to load vmstat gem: #{e}"
    end

    # calculating free and used ram based on: https://github.com/threez/ruby-vmstat/issues/4 to emulate free -m
    mem = Vmstat.snapshot.memory
    begin
      free_ram = mem.available_bytes
    rescue NoMethodError
      free_ram = mem.inactive_bytes + mem.free_bytes
    end
    used_ram = mem.wired_bytes + mem.active_bytes
    total_ram = mem.total_bytes

    # only free or used should be defined, change defaults to mirror free
    if config[:used]
      config[:free] = false
    end

    if config[:megabytes]
      # free_ram is returned in Bytes. see: https://github.com/threez/ruby-vmstat/blob/master/lib/vmstat/memory.rb
      free_ram /= 1024 * 1024
      used_ram /= 1024 * 1024
      # false positive
      total_ram /= 1024 * 1024 # rubocop:disable Lint/UselessAssignment
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
end
