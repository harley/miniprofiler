# Rakefile
require 'rubygems'
require 'bundler'
Bundler.setup(:default, :test)
require "bundler/gem_tasks"

task :default => [:spec]

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

desc "builds a gem"
task :build => :compile_less do
	`gem build rack-mini-profiler.gemspec 1>&2`
end

desc "compile less"
task :compile_less => :copy_files do
  `lessc lib/html/includes.less > lib/html/includes.css`
end


desc "copy files from other parts of the tree"
task :copy_files do
	`rm -R -f lib/html && mkdir lib/html 1>&2`
  path = File.expand_path('./UI')
  `cp -f #{path}/includes.less lib/html/includes.less`
  `cp -f #{path}/includes.js lib/html/includes.js`
  `cp -f #{path}/includes.tmpl lib/html/includes.tmpl`
  `cp -f #{path}/jquery.1.7.1.js lib/html/jquery.1.7.1.js`
  `cp -f #{path}/jquery.tmpl.js lib/html/jquery.tmpl.js`
  `cp -f #{path}/list.css lib/html/list.css`
  `cp -f #{path}/list.js lib/html/list.js`
  `cp -f #{path}/list.tmpl lib/html/list.tmpl`
  `cp -f #{path}/include.partial.html lib/html/profile_handler.js`
end

