# Ensure we require the local version and not one we might have installed already
require File.join([File.dirname(__FILE__),'lib','Sifttter-Redux','constants.rb'])

spec = Gem::Specification.new do |s| 
  s.name = 'sifttter-redux'
  s.version = SifttterRedux::VERSION
  s.author = 'Aaron Bach'
  s.email = 'bachya1208@gmail.com'
  s.homepage = 'https://github.com/bachya/Sifttter-Redux'
  s.platform = Gem::Platform::RUBY
  s.summary = 'Automated IFTTT to Day One engine.'
  s.description = 'Sifttter Redux is a modification of Craig Eley\'s Sifttter that allows for smart installation on a standalone *NIX device (such as a Raspberry Pi).'

  s.files = `git ls-files`.split($/)
  s.test_files = `git ls-files -- test`.split($/)
  s.require_paths << 'lib'
  s.bindir = 'bin'
  s.executables << 'srd'
  
  s.license = 'MIT'
  s.rdoc_options = ['--charset=UTF-8']
  s.extra_rdoc_files = %w[README.md HISTORY.md LICENSE]
  s.rdoc_options << '--title' << 'Sifttter-Redux' << '--main' << 'README.rdoc' << '-ri'
  
  
  s.add_development_dependency('rake', '~> 0')
  s.add_runtime_dependency('chronic', '0.10.2')
  s.add_runtime_dependency('colored','1.2')
  s.add_runtime_dependency('gli','2.9.0')
end
