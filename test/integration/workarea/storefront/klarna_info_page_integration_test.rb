require 'test_helper'

module Workarea
  module Storefront
    class KlarnaInfoPageIntegrationTest < Workarea::IntegrationTest
      def test_klarna_info_page
        Workarea.config.klarna_on_site_messaging_client_id = nil

        get storefront.klarna_path
        assert_response(:missing)

        Workarea.config.klarna_on_site_messaging_client_id = '123-456'

        get storefront.klarna_path
        assert_response(:success)
      end
    end
  end
end
