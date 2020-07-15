module Workarea
  module Klarna
    class Gateway
      class Request
        attr_reader :order, :summary, :path, :method

        def initialize(order)
          @order = order
          @summary = I18n.t('workarea.klarna.gateway.request.base')
          @path = ''
          @method = 'get'
        end

        def validate!
          unless continent_key.present? &&
            subdomain.present? &&
            username.present? &&
            password.present?

            raise Gateway::ContinentNotSupported.new
          end
        end

        def body; end

        def url
          @url ||= begin
            host =
              if Workarea.config.klarna_playground
                "https://#{subdomain}.playground.klarna.com"
              else
                "https://#{subdomain}.klarna.com"
              end

            "#{host}/#{path}"
          end
        end

        def sesssion
          @session ||= Payment::KlarnaSession.find_or_initialize_by(id: order.id)
        end

        def subdomain
          Workarea.config.klarna_subdomains[continent_key]
        end

        def username
          return unless continent_key.present?

          ENV["WORKAREA_KLARNA_#{continent_key}_USERNAME"].presence ||
            rails_credentials[:username] ||
            Workarea.config.send("klarna_#{continent_key.downcase}_username")
        end

        def password
          return unless continent_key.present?

          ENV["WORKAREA_KLARNA_#{continent_key}_PASSWORD"].presence ||
            rails_credentials[:password] ||
            Workarea.config.send("klarna_#{continent_key.downcase}_password")
        end

        def continent
          payment.address&.country&.continent
        end

        def continent_key
          return unless continent.present?
          Workarea.config.klarna_continent_keys[continent]
        end

        private

        def rails_credentials
          return {} unless continent_key.present?
          Rails.application.credentials.klarna[continent_key.downcase.to_sym] || {}
        end

        def order_id
          @order.id
        end

        def payment
          @payment ||= Workarea::Payment.find(order_id)
        rescue Mongoid::Errors::NotFound, Mongoid::Errors::InvalidFind
          @payment = Workarea::Payment.new
        end
      end
    end
  end
end
