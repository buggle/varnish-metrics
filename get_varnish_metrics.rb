#!/usr/bin/ruby
# encoding: utf-8

require 'optparse'

require_relative 'varnish_metrics'

AVAILABLE_OUTPUT_FORMATS = ['text', 'json', 'yaml', 'xml']

options = {}
parser = OptionParser.new do|opts|
  opts.banner = "Usage: get_varnish_metrics.rb --output [ text | json | xml | yaml ] [--instance INSTANCE]"

  opts.on('-i', '--instance instance', 'The varnish instance to be queried') do |instance|
    options[:instance] = instance;
  end

  opts.on('-o', '--output output', "The Output format. Available formats are: #{AVAILABLE_OUTPUT_FORMATS}") do |output|
    options[:output] = output;
  end

  opts.on('-h', '--help', 'Displays Help') do
    puts opts
    exit
  end
end
parser.parse!



if AVAILABLE_OUTPUT_FORMATS.include?(options[:output])
  varnish_metrics = VarnishMetrics.new
  varnish_metrics.dump_metrics(instance: options[:instance], output: options[:output])
else
  puts parser.banner
  puts "* --output FORMAT must be specified"
  puts "* Allowed output formats are: #{AVAILABLE_OUTPUT_FORMATS}"
end
