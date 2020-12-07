require 'workarea/klarna'

module Workarea
  module Klarna
    class Engine < ::Rails::Engine
      include Workarea::Plugin
      isolate_namespace Workarea::Klarna

      config.to_prepare do
        Storefront::ApplicationController.helper(Storefront::KlarnaHelper)
      end
    end
  end
end
