require 'workarea'
require 'workarea/storefront'
require 'workarea/admin'

require 'workarea/klarna/gateway'

module Workarea
  module Klarna
    class << self
      def gateway
        Workarea::Klarna::Gateway.new
      end
    end
  end
end

require 'workarea/klarna/engine'
require 'workarea/klarna/version'
