require 'rake/clean'
require 'rubygems'

def version
  contents = File.read File.expand_path('../lib/sifttter-redux/constants.rb', __FILE__)
  contents[/VERSION = "([^"]+)"/, 1]
end

spec = eval(File.read('sifttter-redux.gemspec'))

require 'rake/testtask'
desc 'Run unit tests'
Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/*_test.rb']
end

require 'cucumber'
require 'cucumber/rake/task'
CUKE_RESULTS = 'results.html'
CLEAN << CUKE_RESULTS
desc 'Run Cucumber features'
Cucumber::Rake::Task.new(:features) do |t|
  opts = "features --format html -o #{CUKE_RESULTS} --format progress -x"
  opts += " --tags #{ENV['TAGS']}" if ENV['TAGS']
  t.cucumber_opts =  opts
  t.fork = false
end

desc "Release Sifttter Redux version #{version}"
task :release => :build do
  unless `git branch` =~ /^\* master$/
    puts "You must be on the master branch to release!"
    exit!
  end
  
  sh "git commit --allow-empty -a -m 'Release #{version}'"
  sh "git tag v#{version}"
  sh "git push origin master"
  sh "git push origin v#{version}"
  sh "gem push pkg/sifttter-redux-#{version}.gem"
end

desc "Build the gem"
task :build do
  FileUtils.mkdir_p "pkg"
  sh "gem build sifttter-redux.gemspec"
  FileUtils.mv("./sifttter-redux-#{version}.gem", "pkg")
end

task :default => [:test, :features]

# require 'rake/clean'
# require 'rubygems'
# require 'rubygems/package_task'
# require 'rdoc/task'
# require 'cucumber'
# require 'cucumber/rake/task'
# Rake::RDocTask.new do |rd|
#   rd.main = "README.rdoc"
#   rd.rdoc_files.include("README.rdoc","lib/**/*.rb","bin/**/*")
#   rd.title = 'Your application title'
# end
# 
# spec = eval(File.read('sifttter_redux.gemspec'))
# 
# Gem::PackageTask.new(spec) do |pkg|
# end
# CUKE_RESULTS = 'results.html'
# CLEAN << CUKE_RESULTS
# desc 'Run features'
# Cucumber::Rake::Task.new(:features) do |t|
#   opts = "features --format html -o #{CUKE_RESULTS} --format progress -x"
#   opts += " --tags #{ENV['TAGS']}" if ENV['TAGS']
#   t.cucumber_opts =  opts
#   t.fork = false
# end
# 
# desc 'Run features tagged as work-in-progress (@wip)'
# Cucumber::Rake::Task.new('features:wip') do |t|
#   tag_opts = ' --tags ~@pending'
#   tag_opts = ' --tags @wip'
#   t.cucumber_opts = "features --format html -o #{CUKE_RESULTS} --format pretty -x -s#{tag_opts}"
#   t.fork = false
# end
# 
# task :cucumber => :features
# task 'cucumber:wip' => 'features:wip'
# task :wip => 'features:wip'
# require 'rake/testtask'
# Rake::TestTask.new do |t|
#   t.libs << "test"
#   t.test_files = FileList['test/*_test.rb']
# end
# 
# task :default => [:test, :features]
