require "benchmark"
$:.unshift "."
require File.dirname(__FILE__) + "/../ext/channel/channel"
require File.dirname(__FILE__) + "/ruby_channel"

channel = Channel.new(16)
16.times{ channel.subscribe{|o| o } }
rb_channel = RubyChannel.new
16.times{ rb_channel.subscribe{|o| o } }

TESTS = 10_000
Benchmark.bmbm do |results|
  results.report("Channel#<<") { TESTS.times { channel << :obj } }  
  results.report("RubyChannel#<<") { TESTS.times { rb_channel << :obj  } }
end