require 'test_helper'

module Workarea
  module Storefront
    class KlarnaSessionIntegrationTest < Workarea::IntegrationTest
      include Storefront::IntegrationTest

      setup :enable_klarna

      def test_session_creation
        product = create_product
        create_shipping_service

        post storefront.cart_items_path,
          params: {
            product_id: product.id,
            sku: product.skus.first,
            quantity: 2
          }

        get storefront.checkout_addresses_path

        VCR.use_cassette('klarna_create_session') do
          patch storefront.checkout_addresses_path,
            headers: checkout_headers,
            params: {
              email: 'test@workarea.com',
              billing_address: factory_defaults(:shipping_address),
              shipping_address: factory_defaults(:billing_address)
            }
        end

        assert_redirected_to(storefront.checkout_shipping_path)

        klarna_session = Payment::KlarnaSession.find(Order.carts.pluck(:id).last)
        assert(klarna_session.session_id.present?)
      end
    end
  end
end
