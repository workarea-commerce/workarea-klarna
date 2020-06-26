module Workarea
  module Klarna
    class Gateway
      class Response
        attr_reader :raw_response

        def initialize(raw_response)
          @raw_response = raw_response
        end

        def body
          @body ||= JSON.parse(raw_response.body)
        end

        def success?
          raw_response.status.in?([200, 201, 202, 204])
        end
      end
    end
  end
end
