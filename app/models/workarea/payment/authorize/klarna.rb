module Workarea
  class Payment
    module Authorize
      class Klarna
        include OperationImplementation

        def complete!
          transaction.response =
            Workarea::Klarna.gateway.authorize(tender, transaction.amount)
        end

        def cancel!
          return unless transaction.success?

          transaction.cancellation = Workarea::Klarna.gateway.cancel(tender)
          tender.clear_authorization!
        end
      end
    end
  end
end
