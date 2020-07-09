module Workarea
  module Klarna
    class Gateway
      class Request
        attr_reader :order, :summary, :path, :method

        def initialize(order)
          @order = order
          @summary = I18n.t('workarea.klarna.gateway.request.base')
          @path = '/'
          @method = 'get'
        end

        def body; end

        def url
          @url ||= begin
            subdomain = Workarea.config.klarna_subdomains[continent]
            raise Gateway::ContinentNotSupported.new unless subdomain.present?

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

        private

        def order_id
          @order.id
        end

        def payment
          @payment ||= Workarea::Payment.find(order_id)
        rescue Mongoid::Errors::NotFound, Mongoid::Errors::InvalidFind
          @payment = Workarea::Payment.new
        end

        def continent
          payment.address&.country&.continent
        end
      end
    end
  end
end
