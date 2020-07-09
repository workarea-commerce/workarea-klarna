module Workarea
  class Payment
    module Purchase
      class Klarna
        include OperationImplementation

        def complete!
          transaction.response =
            Workarea::Klarna.gateway.purchase(tender, transaction.amount)
        end

        def cancel!
          return unless transaction.success?

          transaction.cancellation =
            Workarea::Klarna.gateway.refund(tender, transaction.amount)
        end
      end
    end
  end
end
