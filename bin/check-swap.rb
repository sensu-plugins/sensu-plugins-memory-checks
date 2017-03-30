#!/usr/bin/env ruby

# Looking at vmstat source code in sysinfo.c , 
# the kb_swap_used is kb_swap_total - kb_swap_free,
# so, lets do the same thing.

require 'sensu-plugin/check/cli'

class CheckSwap < Sensu::Plugin::Check::CLI
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
    used_mem = (( mem['total'] - mem['free'] ) / 1024.0 ).round(0)

    if used_mem >= config[:critical]
    critical used_mem.to_s + "MB"
    elsif used_mem >= config[:warning]
    warning used_mem.to_s + "MB"
    else
       ok used_mem.to_s + "MB"
    end
  end

  def metrics_hash
    mem = {}

    meminfo_output.each_line do |line|
      mem['free']      = line.split(/\s+/)[1].to_i if line =~ /^SwapFree/
      mem['total']   = line.split(/\s+/)[1].to_i if line =~ /^SwapTotal/
    end
    mem
  end

  def meminfo_output
    File.open('/proc/meminfo', 'r')
  end
end
