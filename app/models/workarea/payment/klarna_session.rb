module Workarea
  class Payment
    class KlarnaSession
      include ApplicationDocument

      # The _id field will be the order ID
      field :_id, type: String, default: -> { BSON::ObjectId.new.to_s }
      field :session_id, type: String
      field :client_token, type: String
      field :payment_method_categories, type: Hash, default: {}

      index(
        { created_at: 1 },
        { expire_after_seconds: Workarea.config.klarn_session_expiration.to_i }
      )
    end
  end
end
