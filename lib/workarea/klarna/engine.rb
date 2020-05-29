require 'workarea/klarna'

module Workarea
  module Klarna
    class Engine < ::Rails::Engine
      include Workarea::Plugin
      isolate_namespace Workarea::Klarna
    end
  end
end
