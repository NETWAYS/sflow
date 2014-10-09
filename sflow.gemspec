# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sflow/version'

Gem::Specification.new do |spec|
  spec.name          = "sflow"
  spec.version       = Sflow::VERSION
  spec.authors       = ["Sebastian Saemann"]
  spec.email         = ["ssaemann@netways.de"]
  spec.summary       = %q{sflow5 collector and parser}
  spec.description   = %q{parses sflow and sends it to logstash }
  spec.homepage      = "http://www.netways.de"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
end
