module Workarea
  module Klarna
    class Gateway
      class ContinentNotSupported < StandardError; end

      def create_session(order)
        request = CreateSessionRequest.new(order)
        send_request(request)
      end

      def update_session(order, session_id = nil)
        request = UpdateSessionRequest.new(order, session_id)
        send_request(request)
      end

      def authorize(tender, amount)
        request = PlaceOrderRequest.new(tender, amount)
        send_transaction_request(request)
      end

      def purchase(tender, amount)
        request = PlaceOrderRequest.new(order, amount, auto_capture: true)
        send_transaction_request(request)
      end

      def capture(tender, amount)
        request = CaptureRequest.new(tender, amount)
        send_transaction_request(request)
      end

      def refund(tender, amount)
        request = RefundRequest.new(tender, amount)
        send_transaction_request(request)
      end

      def cancel(tender)
        request = CancelRequest.new(tender)
        send_transaction_request(request)
      end

      def release_authorization(tender)
        request = ReleaseRequest.new(tender)
        send_transaction_request(request)
      end

      def send_request(request)
        request.validate!

        raw_response = Faraday.send(request.method, request.url) do |req|
          req.headers['Authorization'] = auth_header(request)
          req.headers['User-Agent'] = "Workarea/#{Workarea::VERSION::STRING}"

          if request.body.present?
            req.headers['Content-Type'] = 'application/json'
            req.body = request.body.to_json
          end
        end

        Response.new(request, raw_response)
      rescue ContinentNotSupported
        unsupported_continent_response(request)
      end

      def send_transaction_request(request)
        response = send_request(request)

        ActiveMerchant::Billing::Response.new(
          response.success?,
          response.message,
          response.params
        )
      end

      private

      def auth_header(request)
        "Basic #{Base64.encode64([request.username, request.password].join(':'))}"
      end

      def unsupported_continent_response(request)
        OpenStruct.new(
          success?: false,
          message: I18n.t(
            'workarea.klarna.gateway.unsupported_continent',
            continent: request.continent
          ),
          params: {}
        )
      end
    end
  end
end
