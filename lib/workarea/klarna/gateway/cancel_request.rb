module Workarea
  module Klarna
    class Gateway
      class CancelRequest < Request
        def initialize(tender)
          @tender = tender
          @payment = tender.payment

          @path = "/ordermanagement/v1/orders/#{tender.order_id}/cancel"
          @method = 'post'
          @summary = I18n.t('workarea.klarna.gateway.request.cancel')
        end
      end
    end
  end
end
