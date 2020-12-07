require 'test_helper'

module Workarea
  module Storefront
    class KlarnaHelperTest < ViewTest
      def test_klarna_on_site_messaging_javacript_tag
        Workarea.config.klarna_on_site_messaging_client_id = nil
        assert_nil(klarna_on_site_messaging_javacript_tag)

        Workarea.config.klarna_on_site_messaging_client_id = '123'
        Workarea.config.klarna_on_site_messaging_region = 'NA'
        Workarea.config.klarna_playground = true

        result = klarna_on_site_messaging_javacript_tag
        assert_includes(result, %(src="https://na-library.playground.klarnaservices.com/lib.js"))
        assert_includes(result, %(async))
        assert_includes(result, %(data-client-id="123"))
        assert_includes(result, %(data-klarna-on-site-messaging))
      end


      def test_klarna_on_site_messaging_url
        Workarea.config.klarna_on_site_messaging_region = 'NA'
        Workarea.config.klarna_playground = true

        assert_equal(
          'https://na-library.playground.klarnaservices.com/lib.js',
          klarna_on_site_messaging_url
        )

        Workarea.config.klarna_playground = false
        assert_equal(
          'https://na-library.klarnaservices.com/lib.js',
          klarna_on_site_messaging_url
        )

        Workarea.config.klarna_on_site_messaging_region = 'EUR'
        assert_equal(
          'https://eu-library.klarnaservices.com/lib.js',
          klarna_on_site_messaging_url
        )
      end
    end
  end
end
