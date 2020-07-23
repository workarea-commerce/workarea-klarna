require 'test_helper'

module Workarea
  module Klarna
    class Gateway
      class CreateSessionRequestTest < TestCase
        setup :create_supporting_data_for_klarna

        def test_details
          request = CreateSessionRequest.new(@order)

          assert_equal('post', request.method)
          assert_equal('payments/v1/sessions', request.path)
          assert(request.summary.present?)
        end

        def test_body
          request = CreateSessionRequest.new(@order)

          assert_nil(request.body[:shipping_address])
          assert_nil(request.body[:billing_address])
        end
      end
    end
  end
end
