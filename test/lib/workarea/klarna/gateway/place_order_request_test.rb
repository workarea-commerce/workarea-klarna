require 'test_helper'

module Workarea
  module Klarna
    class Gateway
      class PlaceOrderRequestTest < TestCase
        setup :create_supporting_data_for_klarna, :add_tender

        def add_tender
          @klarna = create_klarna_tender(payment: @payment)
        end

        def test_details
          request = PlaceOrderRequest.new(@klarna, 14.12.to_m)

          assert_equal('post', request.method)
          assert_equal(
            "/payments/v1/authorizations/#{@klarna.authorization_token}/order",
            request.path
          )
          assert(request.summary.present?)
        end

        def test_body
          request = PlaceOrderRequest.new(@klarna, 14.12.to_m, auto_capture: true)
          assert(request.body[:auto_capture])

          request = PlaceOrderRequest.new(@klarna, 14.12.to_m)
          refute(request.body[:auto_capture])
        end
      end
    end
  end
end
