require 'rake/gempackagetask'

task :clean => :clobber_package

spec = Gem::Specification.new do |s|
  s.name                  = 'resource_controller'
  s.version               = ResourceController::VERSION::STRING
  s.summary               = ""
  s.description           = "Rails RESTful controller abstraction plugin."
  s.author                = "James Golick"
  s.email                 = 'james@giraffesoft.ca'
  s.homepage              = 'http://jamesgolick.com/resource_controller'
  s.has_rdoc              = true

  s.required_ruby_version = '>= 1.8.5'

  s.files                 = %w(README.rdoc README LICENSE init.rb Rakefile) +
                            Dir.glob("{lib,test,generators}/**/*")
  
  s.require_path          = "lib"
end

Rake::GemPackageTask.new(spec) do |p|
  p.gem_spec = spec
end

task :tag_warn do
  puts "*" * 40
  puts "Don't forget to tag the release:"
  puts
  puts "  git tag -a v#{ResourceController::VERSION::STRING}"
  puts
  puts "or run rake tag"
  puts "*" * 40
end

task :tag do
  sh "git tag -a v#{ResourceController::VERSION::STRING}"
end
task :gem => :tag_warn

namespace :gem do
  desc 'Upload gems to rubyforge.org'
  task :release => :gem do
    sh 'rubyforge login'
    sh "rubyforge add_release giraffesoft resource_controller #{ResourceController::VERSION::STRING} pkg/#{spec.full_name}.gem"
    sh "rubyforge add_file    giraffesoft resource_controller #{ResourceController::VERSION::STRING} pkg/#{spec.full_name}.gem"
  end
end

task :install => [:clobber, :package] do
  sh "sudo gem install pkg/#{spec.full_name}.gem"
end

task :uninstall => :clean do
  sh "sudo gem uninstall -v #{ResourceController::VERSION::STRING} -x #{ResourceController::NAME}"
end
