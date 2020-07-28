require 'test_helper'

module Workarea
  module Klarna
    class Gateway
      class UpdateSessionRequestTest < TestCase
        setup :create_supporting_data_for_klarna

        def test_details
          session = create_klarna_session(id: @order.id)
          request = UpdateSessionRequest.new(@order)

          assert_equal('post', request.method)
          assert_equal("payments/v1/sessions/#{session.session_id}", request.path)
          assert(request.summary.present?)
        end

        def test_body
          request = UpdateSessionRequest.new(@order, '123')

          assert_nil(request.body[:shipping_address])
          assert_nil(request.body[:billing_address])
        end
      end
    end
  end
end
