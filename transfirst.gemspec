# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'transfirst/version'

Gem::Specification.new do |spec|
  spec.name          = "transfirst"
  spec.version       = Transfirst::VERSION
  spec.authors       = ["Vagmi Mudumbai"]
  spec.email         = ["vagmi.mudumbai@gmail.com"]
  spec.summary       = %q{TODO: Write a short summary. Required.}
  spec.description   = %q{TODO: Write a longer description. Optional.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.1.0"
  spec.add_development_dependency "pry", '~> 0.10.1'
  spec.add_development_dependency "equivalent-xml", '~> 0.5.1'

  spec.add_dependency "savon", "~> 2.8.1"
  spec.add_dependency "nokogiri", "~> 1.6.5"
end
