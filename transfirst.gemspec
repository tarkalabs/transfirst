# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'transfirst/version'

Gem::Specification.new do |spec|
  spec.name          = "transfirst"
  spec.version       = Transfirst::VERSION
  spec.authors       = ["Vagmi Mudumbai"]
  spec.email         = ["vagmi.mudumbai@gmail.com"]
  spec.summary       = %q{This gem provides methods for setting up recurring billing with Transfirst}
  spec.description   = %q{This gem provides methods for setting up recurring billing with Transfirst}
  spec.homepage      = "https://github.com/JJCOINCWEBDEV/transfirst"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "simplecov", "~> 0.9.1"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.1.0"
  spec.add_development_dependency "pry", '~> 0.10.1'
  spec.add_development_dependency "equivalent-xml", '~> 0.5.1'
  spec.add_development_dependency "dotenv", '~> 1.0.2'
  spec.add_development_dependency "codeclimate-test-reporter", '~> 0.4.6'
  spec.add_development_dependency "faker", '~> 1.4.3'

  spec.add_dependency "savon", "~> 2.7.2"
  spec.add_dependency "nokogiri", "~> 1.4"
  spec.add_dependency "activemodel", "~> 4.0"
end
