class RubyChannel
  def initialize(size = 1,defer = false)
    @size = size
    @subscribers = []
    @defer = defer
  end
  def subscribe(&b)
    raise ArgumentError.new("Maximum number of subscribers exceeded!") unless @subscribers.size < @size
    @subscribers << b
    self
  end
  def <<(o)
    unless @defer
      @subscribers.each { |s| s.call(o) }
    else
      Thread.new{ @subscribers.each { |s| s.call(o) } }
    end
  end
end