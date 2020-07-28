module Workarea
  module Klarna
    class Gateway
      class UpdateSessionRequest < Request
        def initialize(order, session_id = nil)
          super(order)

          @session_id = session_id || find_session_id

          @path = "payments/v1/sessions/#{@session_id}"
          @method = 'post'
          @summary = I18n.t('workarea.klarna.gateway.request.update_session')
        end

        def body
          Gateway::Order
            .new(order, payment: payment)
            .to_h
            .except(:shipping_address, :billing_address)
        end

        private

        def find_session_id
          Payment::KlarnaSession.find_or_initialize_by(id: order.id).session_id
        end
      end
    end
  end
end
