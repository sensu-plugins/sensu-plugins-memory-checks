#!/usr/bin/env ruby

bin_dir = File.expand_path(File.dirname(__FILE__))
shell_script_path = File.join(bin_dir, 'check-swap-percent.sh')

exec shell_script_path, *ARGV
