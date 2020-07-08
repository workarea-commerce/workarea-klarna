module Workarea
  module Klarna
    class Gateway
      class RequestError < StandardError; end
      class ContinentNotSupported < StandardError; end

      def configured?
        username.present? && password.present?
      end

      def create_session(order)
        request = CreateSessionRequest.new(order)
        send_request(request)
      rescue ContinentNotSupported
        Response.new(request, nil)
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

        ActiveMerchant::Billing::Response.new(

        )
      end

      def refund(tender, amount)

      end

      def cancel(tender, amount = nil)

      end

      def send_request(request)
        raw_response = Faraday.send(request.method, request.url) do |req|
          req.headers['Authorization'] = auth_header
          req.headers['User-Agent'] = "Workarea/#{Workarea::VERSION::STRING}"

          if request.body.present?
            req.headers['Content-Type'] = 'application/json'
            req.body = request.body.to_json
          end

          yield if block_given?
        end

        Response.new(request, raw_response)
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

      def username
        ENV['WORKAREA_KLARNA_USERNAME'].presence ||
          Rails.application.credentials.klarna.try(:[], :username) ||
          Workarea.config.klarna_username
      end

      def password
        ENV['WORKAREA_KLARNA_PASSWORD'].presence ||
          Rails.application.credentials.klarna.try(:[], :password) ||
          Workarea.config.klarna_password
      end

      def auth_header
        "Basic #{Base64.encode64([username, password].join(':'))}"
      end

      def throw_request_error(error)
        raise RequestError.new(
          I18n.t(
            'workarea.klarna.gateway.http_error',
            status: error.status_code
          )
        )
      end

      def handle_connection_errors
        begin
          yield
        rescue StandardError => error
          Rails.logger.error(error.message)
          Rails.logger.error(error.result)
          throw_request_error(error)
        end
      end
    end
  end
end
