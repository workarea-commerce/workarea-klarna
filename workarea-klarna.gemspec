$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "workarea/klarna/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "workarea-klarna"
  spec.version     = Workarea::Klarna::VERSION
  spec.authors     = ["Matt Duffy"]
  spec.email       = ["mduffy@workarea.com"]
  spec.homepage    = "https://www.workarea.com"
  spec.summary     = "Klarna API integration for the Workarea Commerce Platform."
  spec.description = "Klarna Payments and Order Management API integration with Workarea Commerce."
  spec.license     = "Business Software License"

  spec.files = `git ls-files`.split("\n")

  spec.add_dependency 'workarea', '~> 3.5.x'
end
