module Workarea
  module Klarna
    class Gateway
      class UpdateSessionRequest < Request
        def initialize(order)
          super

          @path = "payments/v1/sessions/#{session&.id}"
          @method = 'post'
        end

        def body
          Gateway::Order.new(order, payment: payment).to_hash
        end
      end
    end
  end
end
