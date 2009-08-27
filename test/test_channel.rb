$:.unshift "."
require File.dirname(__FILE__) + '/helper'

class TestChannel < Test::Unit::TestCase
  
  def test_initialize
    assert_instance_of Channel, Channel.new
    assert_raises(ArgumentError){ Channel.new(-1)  }
    assert_raises(ArgumentError){ Channel.new(33)  }    
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
  
  def test_push
    @counter = 0
    ch = Channel.new.subscribe{|obj| @counter += obj }
    ch << 3
    ch << -2
    assert_equal 1, @counter
  end
end