require 'workarea'
require 'workarea/storefront'
require 'workarea/admin'

require 'workarea/klarna/gateway'
require 'workarea/klarna/gateway/request'
require 'workarea/klarna/gateway/response'
require 'workarea/klarna/gateway/order'
require 'workarea/klarna/gateway/create_session_request'
require 'workarea/klarna/gateway/update_session_request'
require 'workarea/klarna/gateway/place_order_request'
require 'workarea/klarna/gateway/capture_request'
require 'workarea/klarna/gateway/refund_request'
require 'workarea/klarna/gateway/cancel_request'
require 'workarea/klarna/gateway/release_request'
require 'workarea/klarna/bogus_gateway'

module Workarea
  module Klarna
    class << self
      def gateway
        return Klarna::BogusGateway.new unless Workarea.config.load_klarna
        Klarna::Gateway.new
      end
    end
  end
end

require 'workarea/klarna/engine'
require 'workarea/klarna/version'
