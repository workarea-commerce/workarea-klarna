module Workarea
  class Payment
    class Capture
      class Klarna
        include OperationImplementation

        def complete! # TODO
          transaction.response =
            Workarea::Klarna.gateway.capture(tender, transaction.amount)
        end

        def cancel! # TODO
          transaction.cancellation =
            Workarea::Klarna.gateway.refund(tender, transaction.amount)
        end
      end
    end
  end
end
