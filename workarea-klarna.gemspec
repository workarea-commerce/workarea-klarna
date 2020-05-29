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

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files = `git ls-files`.split("\n")

  spec.add_dependency 'workarea', '~> 3.5.x'
end
