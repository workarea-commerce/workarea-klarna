module Workarea
  class Payment
    class Tender
      class Klarna < Tender
        field :authorization_token, type: String
        field :authorization_token_expires_at, type: Time
        field :payment_method_category, type: String

        embedded_in :payment, class_name: 'Workarea::Payment'

        def slug
          :klarna
        end

        def authorization_token=(val)
          if val.present? && authorization_token != val
            self.authorization_token_expires_at = 1.hour.from_now
          end

          super
        end

        def authorization_token_expired?
          authorization_token.present? &&
            authorization_token_expires_at < Time.current
        end

        def clear_authorization!
          update!(
            authorization_token: nil,
            authorization_token_expires_at: nil
          )
        end

        def placed_order_data
          txn = transactions.successful.not_canceled.authorizes.first ||
                transactions.successful.not_canceled.captures_or_purchased.first

          return {} unless txn.present?
          txn.response.params
        end

        def order_id
          placed_order_data['order_id']
        end

        def redirect_url
          placed_order_data['redirect_url']
        end
      end
    end
  end
end
