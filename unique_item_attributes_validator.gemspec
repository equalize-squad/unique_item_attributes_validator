# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "unique_item_attributes_validator/version"

Gem::Specification.new do |spec|
  spec.name          = "unique_item_attributes_validator"
  spec.version       = UniqueItemAttributesValidator::VERSION
  spec.authors       = ["ddomingues", "roalcantara"]
  spec.email         = ["diego.domingues16@gmail.com", "rogerio.alcantara@gmail.com"]

  spec.summary       = "Collection items attributes uniqueness validator"
  spec.description   = "A simple validator to verify the uniqueness of certain attributes from a collection"
  spec.homepage      = "https://github.com/equalize-squad/unique_item_attributes_validator"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "activemodel"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 3.5"
end
