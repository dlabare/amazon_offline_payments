# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'amazon_offline_payments/version'

Gem::Specification.new do |spec|
  spec.name          = "amazon_offline_payments"
  spec.version       = AmazonOfflinePayments::VERSION
  spec.authors       = ["Daniel LaBare"]
  spec.email         = ["dlabare@gmail.com"]
  spec.summary       = %q{ActiveMerchant extension for Amazon Offline Payments}
  spec.description   = %q{}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_dependency "activemerchant"
end
