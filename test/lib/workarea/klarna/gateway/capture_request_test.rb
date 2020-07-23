require 'test_helper'

module Workarea
  module Klarna
    class Gateway
      class CaptureRequestTest < TestCase
        def tender
          OpenStruct.new(payment: nil, order_id: '123')
        end

        def test_details
          request = CaptureRequest.new(tender, 5.to_m)

          assert_equal('post', request.method)
          assert_equal('/ordermanagement/v1/orders/123/captures', request.path)
          assert(request.summary.present?)
        end

        def test_body
          request = CaptureRequest.new(tender, 5.to_m)
          assert_equal({ captured_amount: 500 }, request.body)
        end
      end
    end
  end
end
