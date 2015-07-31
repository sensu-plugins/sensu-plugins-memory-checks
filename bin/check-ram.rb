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
#
# NOTES:
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
         description: 'Unless --megabytes is specified the thresholds are in percents',
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
    total_ram = free = cached = buffers = shmem = 0

    File.open("/proc/meminfo") do |file|
      content = file.read()

      content.scan(/(\w+):\s+(\d+) kB/) do |name, kbytes|
        case name
          when "MemTotal" then total_ram = kbytes.to_i
          when "MemFree"  then free      = kbytes.to_i
          when "Cached"   then cached    = kbytes.to_i
          when "Buffers"  then buffers   = kbytes.to_i
          when "Shmem"    then shmem     = kbytes.to_i
        end
      end
    end

    # we don't care about buffers/cache
    free_ram = free + cached + buffers + shmem

    if config[:megabytes]
      free_ram = free_ram / 1024
      message "#{free_ram} megabytes free RAM left"

      critical if free_ram < config[:crit]
      warning if free_ram < config[:warn]
      ok
    else
      unknown 'invalid percentage' if config[:crit] > 100 || config[:warn] > 100

      percents_left = free_ram * 100 / total_ram
      message "#{percents_left}% free RAM left"

      critical if percents_left < config[:crit]
      warning if percents_left < config[:warn]
      ok
    end
  end
end
