#! /usr/bin/env ruby
# frozen_string_literal: true

#
#   metrics-memory-vmstat
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
#
# NOTES:
#
# LICENSE:
#   Zubov Yuri <yury.zubau@gmail.com> sponsored by Actility, https://www.actility.com
#   Released under the same terms as Sensu (the MIT license); see LICENSE
#   for details.
#
require 'sensu-plugin/metric/cli'
require 'socket'

class MetricsSoftnetStat < Sensu::Plugin::Metric::CLI::Graphite
  option :scheme,
         description: 'Metric naming scheme, text to prepend to metric',
         short: '-s SCHEME',
         long: '--scheme SCHEME',
         default: "#{Socket.gethostname}.vmstat"

  option :proc_path,
         long: '--proc-path /proc',
         proc: proc(&:to_s),
         default: '/proc'

  def run
    File.open("#{config[:proc_path]}/vmstat", 'r').each_line do |line|
      result = line.match(/(?<metric_name>\w+)[[:space:]]+(?<value>\d+)/)
      output "#{config[:scheme]}.#{result[:metric_name]}", result[:value]
    end
    ok
  end
end
