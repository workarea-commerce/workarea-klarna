module Workarea
  class Payment
    module Purchase
      class Klarna
        include OperationImplementation

        def complete!
          transaction.response =
            Workarea::Klarna.gateway.purchase(tender, transaction.amount)
        end

        def cancel! # TODO
          transaction.cancellation = Workarea::Klarna.gateway.cancel(tender)
        end
      end
    end
  end
end
