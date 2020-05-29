module Workarea
  module Klarna
    class Gateway
      class RequestError < StandardError; end

      def configured?
        username.present? && password.present?
      end

      def create_session(order)

      end

      def update_session(order)

      end

      def create_order(order)

      end

      def capture(order_id, amount)

      end

      def refund(order_id, amount)

      end

      def cancel(order_id, data)

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
