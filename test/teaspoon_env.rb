require 'workarea/testing/teaspoon'

Teaspoon.configure do |config|
  config.root = Workarea::Klarna::Engine.root
  Workarea::Teaspoon.apply(config)
end
