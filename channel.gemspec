Gem::Specification.new do |s|
  s.name     = "channel"
  s.version  = "1.0.1"
  s.date     = "2009-08-28"
  s.summary  = "Native MRI channel"
  s.email    = "lourens@methodmissing.com"
  s.homepage = "http://github.com/methodmissing/channel"
  s.description = "Simple native Channel object for Ruby MRI (1.8.{6,7} and 1.9.2)"
  s.has_rdoc = true
  s.authors  = ["Lourens Naudé (methodmissing)","James Tucker (raggi)"]
  s.platform = Gem::Platform::RUBY
  s.files    = %w[
    README
    Rakefile
    bench/bench.rb
    bench/ruby_channel.rb
    ext/channel/extconf.rb
    ext/channel/channel.c
    channel.gemspec
  ] + Dir.glob('test/*')
  s.rdoc_options = ["--main", "README"]
  s.extra_rdoc_files = ["README"]
  s.extensions << "ext/channel/extconf.rb"
end