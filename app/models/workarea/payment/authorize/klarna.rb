module Workarea
  class Payment
    module Authorize
      class Klarna
        include OperationImplementation

        def complete!
          transaction.response =
            Workarea::Klarna.gateway.authorize(tender, transaction.amount)
        end

        def cancel! # TODO
          transaction.cancellation = Workarea::Klarna.gateway.cancel(tender)
        end
      end
    end
  end
end
