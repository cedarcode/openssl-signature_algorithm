# frozen_string_literal: true

require_relative 'lib/openssl/signature_algorithm/version'

Gem::Specification.new do |spec|
  spec.name          = "openssl-signature_algorithm"
  spec.version       = OpenSSL::SignatureAlgorithm::VERSION
  spec.authors       = ["Gonzalo"]
  spec.email         = ["gonzalo@cedarcode.com"]

  spec.summary       = "Signature Algorithm abstraction on top of openssl ruby gem"
  spec.homepage      = "https://github.com/cedarcode/openssl-signature_algorithm"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.5.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/master/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
