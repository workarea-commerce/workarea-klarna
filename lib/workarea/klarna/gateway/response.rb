module Workarea
  module Klarna
    class Gateway
      class Response
        attr_reader :raw_response

        def initialize(raw_response)
          @raw_response = raw_response
        end

        def body
          JSON.parse(raw_response.body)
        end
      end
    end
  end
end
