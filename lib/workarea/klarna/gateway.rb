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
        # Return null option set
      end

      def update_session(order)
        request = UpdateSessionRequest.new(order)
        send_request(request)
      end

      def create_order(order)

      end

      def capture(order_id, amount)

      end

      def refund(order_id, amount)

      end

      def cancel(order_id, data)

      end

      def send_request(request)
        raw_response = Faraday.send(request.method, request.url) do |request|
          request.headers['Authorization'] = auth_header
          request.headers['User-Agent'] = "Workarea/#{Workarea::VERSION::STRING}"

          if request.body.present?
            request.headers['Content-Type'] = 'application/json'
            request.body = request.body.to_json
          end

          yield
        end

        Response.new(raw_response)
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
