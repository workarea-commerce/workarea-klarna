module Workarea
  module Klarna
    class Gateway
      class PlaceOrderRequest < Request
        def initialize(tender, amount, auto_capture: false)
          super(Workarea::Order.find(tender.payment.id))

          @tender = tender
          @payment = tender.payment
          @amount = amount
          @auto_capture = auto_capture

          @path = "/payments/v1/authorizations/#{authorization_token}/order"
          @method = 'post'
          @summary = I18n.t(
            'workarea.klarna.gateway.request.place_order',
            amount: @amount.format
          )
        end

        def body
          Gateway::Order
            .new(order, payment: payment)
            .to_h
            .merge(auto_capture: @auto_capture)
        end

        def authorization_token
          payment.klarna.authorization_token
        end
      end
    end
  end
end
