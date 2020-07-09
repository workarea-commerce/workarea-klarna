module Workarea
  module Klarna
    class Gateway
      class RefundRequest < Request
        def initialize(tender, amount)
          @tender = tender
          @payment = tender.payment
          @amount = amount

          @path = "/ordermanagement/v1/orders/#{tender.order_id}/refunds"
          @method = 'post'
          @summary = I18n.t(
            'workarea.klarna.gateway.request.refund',
            amount: @amount.format
          )
        end

        def body
          { refunded_amount: @amount.cents }
        end
      end
    end
  end
end
