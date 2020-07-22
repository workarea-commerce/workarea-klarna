module Workarea
  module Klarna
    class BogusGateway
      def respond_to_missing?(method_name, include_private = false)
        Gateway.new.respond_to?(method_name)
      end

      def method_missing(method_name, *args)
        return super unless Gateway.new.respond_to?(method_name)

        OpenStruct.new(
          success?: false,
          message: 'This is a bogus gateway',
          params: {}
        )
      end
    end
  end
end
