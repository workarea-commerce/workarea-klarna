module Workarea
  module Klarna
    class Gateway
      class CreateSessionRequest < Request
        def initialize(order)
          super

          @path = 'payments/v1/sessions'
          @method = 'post'
          @summary = I18n.t('workarea.klarna.gateway.request.create_session')
        end

        def body
          Gateway::Order
            .new(order, payment: payment)
            .to_h
            .except(:shipping_address, :billing_address)
        end
      end
    end
  end
end
