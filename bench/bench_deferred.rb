require "benchmark"
$:.unshift "."
require File.dirname(__FILE__) + "/../ext/channel/channel"
require File.dirname(__FILE__) + "/ruby_channel"

channel = Channel.new(16,true)
16.times{ channel.subscribe{|o| o } }
rb_channel = RubyChannel.new(16,true)
16.times{ rb_channel.subscribe{|o| o } }

TESTS = 30
Benchmark.bmbm do |results|
  results.report("Channel#<<") { TESTS.times { channel << 2 } }  
  results.report("RubyChannel#<<") { TESTS.times { rb_channel << 2 } }
end