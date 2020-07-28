module Workarea
  module Klarna
    class Gateway
      class Response
        attr_reader :request, :raw_response

        def initialize(request, raw_response)
          @request = request
          @raw_response = raw_response
        end

        def body
          @body ||=
            if raw_response&.body.present?
              JSON.parse(raw_response.body)
            else
              {}
            end
        end

        alias_method :params, :body

        def success?
          raw_response.present? && raw_response.status.in?([200, 201, 202, 204])
        end

        def message
          if success?
            I18n.t('workarea.klarna.gateway.response.success', summary: request.summary)
          else
            errors = body.fetch('error_messages', []).join('. ')
            I18n.t('workarea.klarna.gateway.response.failure', summary: errors)
          end
        end
      end
    end
  end
end
