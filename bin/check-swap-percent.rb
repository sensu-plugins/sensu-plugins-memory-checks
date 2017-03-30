#!/usr/bin/env ruby

# Looking at vmstat source code in sysinfo.c , 
# the kb_swap_used is kb_swap_total - kb_swap_free,
# so, lets do the same thing.

require 'sensu-plugin/check/cli'

class CheckSwap < Sensu::Plugin::Check::CLI
  option :warning,
         short: '-w warning',
		 proc: proc(&:to_i),
         default: 0

  option :critical,
         short: '-c critical',
		 proc: proc(&:to_i),
         default: 0


  def run
    mem = metrics_hash
    used_mem = mem['total'] - mem['free']
	percent = (( used_mem.to_f / mem['total'].to_f ) * 100).round(2)	

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
      mem['free']      = line.split(/\s+/)[1].to_i if line =~ /^SwapFree/
      mem['total']   = line.split(/\s+/)[1].to_i if line =~ /^SwapTotal/
    end
    mem
  end

  def meminfo_output
    File.open('/proc/meminfo', 'r')
  end
end
