# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sifttter-redux/constants'

Gem::Specification.new do |spec|
  spec.name             = 'sifttter-redux'
  spec.version          = SifttterRedux::VERSION
  spec.authors          = ['Aaron Bach']
  spec.email            = ['bachya1208@googlemail.com']
  spec.summary          = SifttterRedux::SUMMARY
  spec.description      = SifttterRedux::DESCRIPTION
  spec.homepage         = 'https://github.com/bachya/sifttter-redux'
  spec.license          = 'MIT'
  spec.platform         = Gem::Platform::RUBY

  spec.require_paths    = ["lib"]
  spec.files            = `git ls-files`.split("\n")
  spec.executables      = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files       = spec.files.grep(%r{^(test|spec|features)/})

  spec.license          = 'MIT'
  spec.rdoc_options     = ['--charset=UTF-8']
  spec.extra_rdoc_files = %w[README.md HISTORY.md LICENSE]

  spec.add_development_dependency('rake', '10.1.1')
  spec.add_development_dependency('rdoc', '4.1.1')
  spec.add_development_dependency('aruba', '0.5.4')
  spec.add_runtime_dependency('archive-zip', '0.6.0')
  spec.add_runtime_dependency('chronic', '0.10.2')
  spec.add_runtime_dependency('cliutils', '~> 2')
  spec.add_runtime_dependency('gli','2.9.0')
  spec.add_runtime_dependency('htmlentities','4.3.1')
end
