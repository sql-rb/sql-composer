# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "sql/builder/version"

Gem::Specification.new do |spec|
  spec.name          = "sql-builder"
  spec.version       = SQL::Builder::VERSION
  spec.authors       = ["Piotr Solnica"]
  spec.email         = ["piotr.solnica@gmail.com"]

  spec.summary       = ""
  spec.description   = ""
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f|
    f.match(%r{^(test|spec|features)/})
  }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
