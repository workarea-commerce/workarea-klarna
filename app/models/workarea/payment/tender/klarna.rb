module Workarea
  class Payment
    class Tender
      class Klarna < Tender
        field :authorization_token, type: String
        field :payment_method_category, type: String

        def slug
          :klarna
        end
      end
    end
  end
end
