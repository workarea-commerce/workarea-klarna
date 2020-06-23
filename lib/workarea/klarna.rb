require 'workarea'
require 'workarea/storefront'
require 'workarea/admin'

require 'workarea/klarna/gateway'
require 'workarea/klarna/gateway/request'
require 'workarea/klarna/gateway/response'
require 'workarea/klarna/gateway/order'
require 'workarea/klarna/gateway/create_session_request'
require 'workarea/klarna/gateway/update_session_request'

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
