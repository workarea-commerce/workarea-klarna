module Workarea
  module Klarna
    class Gateway
      class ReleaseRequest < Request
        def initialize(tender)
          @tender = tender
          @payment = tender.payment

          @path = "/ordermanagement/v1/orders/#{tender.order_id}/release-remaining-authorization"
          @method = 'post'
          @summary = I18n.t('workarea.klarna.gateway.request.release')
        end
      end
    end
  end
end
