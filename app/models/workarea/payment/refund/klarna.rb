module Workarea
  class Payment
    class Refund
      class Klarna
        include OperationImplementation

        def complete!
          transaction.response =
            Workarea::Klarna.gateway.refund(tender, transaction.amount)
        end

        def cancel!
          # noop
        end
      end
    end
  end
end
