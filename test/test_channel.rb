$:.unshift "."
require File.dirname(__FILE__) + '/helper'
require 'timeout'

class TestChannel < Test::Unit::TestCase
  
  def test_initialize
    assert_instance_of Channel, Channel.new
    assert_raises(ArgumentError){ Channel.new(-1)  }
    assert_raises(ArgumentError){ Channel.new(33)  }    
  end
  
  def test_initialize_deferrable
    assert !Channel.new(10).deferrable?
    assert Channel.new(10,true).deferrable?    
  end
  
  def test_size
    assert_equal 10, Channel.new(10).size
  end
  
  def test_subscribers
    assert_equal 0, Channel.new(10).subscribers
  end
  
  def test_subscribe
    assert_equal 1, Channel.new.subscribe{|obj| obj }.subscribers
    assert_raises(ArgumentError){ Channel.new.subscribe }
    assert_raises(ArgumentError){ Channel.new.subscribe(:arg) }    
  end 
  
  def test_subscriber_threshold
    ch = Channel.new(3)
    assert_raises ArgumentError do
      4.times{ ch.subscribe{|o| o } }
    end
  end
  
  def test_push
    @counter = 0
    ch = Channel.new.subscribe{|obj| @counter += obj }
    ch << 3
    ch << -2
    assert_equal 1, @counter
  end
  
  def test_push_deferred
    ch = Channel.new(3).subscribe{|obj| sleep(obj) }    
    assert_raises Timeout::Error do
      Timeout.timeout(0.8) do
        ch << 1
      end
    end  
    ch = Channel.new(3,true).subscribe{|obj| sleep(obj) }    
    assert_nothing_raised do
      Timeout.timeout(0.8) do
        ch << 1
        ch << 2
        ch << 3
      end
    end
    ch << 0.5
    sleep 0.7
  end  
end