module Workarea
  module Klarna
    class Gateway
      class CaptureRequest < Request
        def initialize(tender, amount)
          @tender = tender
          @payment = tender.payment
          @amount = amount

          @path = "/ordermanagement/v1/orders/#{tender.order_id}/captures"
          @method = 'post'
          @summary = I18n.t(
            'workarea.klarna.gateway.request.capture',
            amount: @amount.format
          )
        end

        def body
          { captured_amount: @amount.cents }
        end
      end
    end
  end
end
