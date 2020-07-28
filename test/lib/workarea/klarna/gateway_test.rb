require 'test_helper'

module Workarea
  module Klarna
    class GatewayTest < TestCase
      setup :configure_klarna_data, :payment

      def order
        @order ||= create_order
      end

      def payment
        @payment ||= create_payment(id: order.id)
      end

      def request
        Gateway::Request.new(order)
      end

      def test_send_request
        response = Gateway.new.send_request(request)
        refute(response.success?)
        assert_equal(
          t('workarea.klarna.gateway.unsupported_continent', continent: nil),
          response.message
        )

        payment.set_address(unsupported_address)
        response = Gateway.new.send_request(request)
        refute(response.success?)
        assert_equal(
          t('workarea.klarna.gateway.unsupported_continent', continent: 'South America'),
          response.message
        )

        payment.set_address(supported_na_address)

        Faraday.expects(:send)
               .with('get', 'https://api-na.playground.klarna.com/')

        response = Gateway.new.send_request(request)
      end

      def test_send_transaction_request
        payment.set_address(supported_na_address)
        Faraday.expects(:send).returns(
          OpenStruct.new(status: 200, body: { foo: 'bar' }.to_json)
        )

        response = Gateway.new.send_transaction_request(request)

        assert(response.is_a?(ActiveMerchant::Billing::Response))
        assert(response.success?)
        assert_equal({ 'foo' => 'bar' }, response.params)
      end
    end
  end
end
