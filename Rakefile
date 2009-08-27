require 'rake'
require 'rake/testtask'
require 'rake/clean'

CH_ROOT = 'ext/channel'

desc 'Default: test'
task :default => :test

desc 'Run channel tests.'
Rake::TestTask.new(:test) do |t|
  t.libs = [CH_ROOT]
  t.pattern = 'test/test_*.rb'
  t.verbose = true
end
task :test => :build

namespace :build do
  file "#{CH_ROOT}/channel.c"
  file "#{CH_ROOT}/extconf.rb"
  file "#{CH_ROOT}/Makefile" => %W(#{CH_ROOT}/channel.c #{CH_ROOT}/extconf.rb) do
    Dir.chdir(CH_ROOT) do
      ruby 'extconf.rb'
    end
  end

  desc "generate makefile"
  task :makefile => %W(#{CH_ROOT}/Makefile #{CH_ROOT}/channel.c)

  dlext = Config::CONFIG['DLEXT']
  file "#{CH_ROOT}/channel.#{dlext}" => %W(#{CH_ROOT}/Makefile #{CH_ROOT}/channel.c) do
    Dir.chdir(CH_ROOT) do
      sh 'make' # TODO - is there a config for which make somewhere?
    end
  end

  desc "compile channel extension"
  task :compile => "#{CH_ROOT}/channel.#{dlext}"

  task :clean do
    Dir.chdir(CH_ROOT) do
      sh 'make clean'
    end if File.exists?("#{CH_ROOT}/Makefile")
  end

  CLEAN.include("#{CH_ROOT}/Makefile")
  CLEAN.include("#{CH_ROOT}/channel.#{dlext}")
end

task :clean => %w(build:clean)

desc "compile"
task :build => %w(build:compile)

task :install do |t|
  Dir.chdir(CH_ROOT) do
    sh 'sudo make install'
  end
end

desc "clean build install"
task :setup => %w(clean build install)

desc "run benchmarks"
task :bench do |t|
  ruby "bench/bench.rb"  
end
task :bench => :build