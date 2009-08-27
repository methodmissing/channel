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
    
end