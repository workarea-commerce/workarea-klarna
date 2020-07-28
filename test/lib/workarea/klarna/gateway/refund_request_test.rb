require 'test_helper'

module Workarea
  module Klarna
    class Gateway
      class RefundRequestTest < TestCase
        def tender
          OpenStruct.new(payment: nil, order_id: '123')
        end

        def test_details
          request = RefundRequest.new(tender, 5.to_m)

          assert_equal('post', request.method)
          assert_equal('/ordermanagement/v1/orders/123/refunds', request.path)
          assert(request.summary.present?)
        end

        def test_body
          request = RefundRequest.new(tender, 5.to_m)
          assert_equal({ refunded_amount: 500 }, request.body)
        end
      end
    end
  end
end
