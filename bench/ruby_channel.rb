class RubyChannel
  def initialize
    @subscribers = []
  end
  def subscribe(&b)
    @subscribers << b
    self
  end
  def <<(o)
    @subscribers.each { |s| s.call(o) }
  end
end