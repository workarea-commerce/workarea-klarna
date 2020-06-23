module Workarea
  module Klarna
    class Gateway
      class PlaceOrderRequest < Request
        def initialize(order)
          super

          @path = "/payments/v1/authorizations/#{authorization_token}/order"
          @method = 'post'
        end

        def body
          Gateway::Order.new(order, payment: payment).to_hash
        end

        def authorization_token
          payment.klarna.authorization_token
        end
      end
    end
  end
end
