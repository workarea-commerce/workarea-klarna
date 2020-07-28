module Workarea
  class SetupKlarnaSession
    delegate :order, :payment, to: :@checkout

    def initialize(checkout)
      @checkout = checkout
    end

    def perform
      return unless payment.eligible_for_klarna?

      session = Payment::KlarnaSession.find_or_initialize_by(id: order.id)

      if session.persisted?
        Klarna.gateway.update_session(order, session.session_id)
      else
        response = Klarna.gateway.create_session(order)
        return unless response.success?

        session.update!(response.body)
      end
    end
  end
end
