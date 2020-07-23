require 'test_helper'

module Workarea
  module Klarna
    class Gateway
      class OrderTest < TestCase
        setup :supporting_data

        def supporting_data
          create_tax_category(
            name: 'Sales Tax',
            code: '001',
            rates: [
              { percentage: 0.07, country: 'US', region: 'PA' },
              { percentage: 0.09, country: 'DE', region: 'BY' }
            ]
          )

          @product = create_product(
            id: 'INT_PRODUCT',
            name: 'Integration Product',
            variants: [{ sku: 'SKU',  tax_code: '001', regular: 5.to_m }]
          )

          @category = create_category(name: 'Pants', product_ids: [@product.id])
          create_taxon(name: 'Pants', navigable: @category)

          create_order_total_discount

          card = create_saved_credit_card
          profile = card.profile
          profile.update!(store_credit: 3.to_m)

          user = Workarea::User.find(profile.reference)

          @order = create_order(
            user_id: user.id,
            email: user.email,
            items: [{
                product_id: 'INT_PRODUCT',
                sku: 'SKU',
                quantity: 2,
                via: @category.to_gid_param
            }]
          )

          @payment = create_payment(
            id: @order.id,
            address: supported_na_address,
            store_credit: { amount: 3.to_m }
          )

          @shipping = create_shipping(
            order_id: @order.id,
            address: supported_na_address
          )

          @shipping.apply_shipping_service(
            name: 'Ground',
            tax_code: '001',
            base_price: 7.to_m
          )
        end

        def price_order
          Workarea::Pricing.perform(@order, @shipping)
        end

        def test_to_h_for_na
          price_order

          result = Order.new(@order).to_h
          assert(result.present?)

          assert_equal('US', result[:purchase_country])
          assert_equal('USD', result[:purchase_currency])
          assert_equal(1412, result[:order_amount])
          assert_equal(112, result[:order_tax_amount])

          assert_equal(5, result[:order_lines].size)

          line = result[:order_lines].first
          assert_equal('Integration Product', line[:name])
          assert_equal('physical', line[:type])
          assert_equal('SKU', line[:reference])
          assert_equal(2, line[:quantity])
          assert_equal(500, line[:unit_price])
          assert_equal(1000, line[:total_amount])
          assert_nil(line[:total_tax_amount])
          assert_nil(line[:tax_rate])
          assert_includes(line[:product_url], '/products/integration-product')
          assert_equal('Home > Pants', line[:product_identifiers][:category_path])

          line = result[:order_lines].second
          assert_equal('Shipping', line[:name])
          assert_equal('shipping_fee', line[:type])
          assert_equal(1, line[:quantity])
          assert_equal(700, line[:unit_price])
          assert_equal(700, line[:total_amount])
          assert_nil(line[:total_tax_amount])
          assert_nil(line[:tax_rate])

          line = result[:order_lines].third
          assert_equal('Order Discounts', line[:name])
          assert_equal('discount', line[:type])
          assert_equal(1, line[:quantity])
          assert_equal(-100, line[:unit_price])
          assert_equal(-100, line[:total_amount])
          assert_nil(line[:total_tax_amount])
          assert_nil(line[:tax_rate])

          line = result[:order_lines].fourth
          assert_equal('Tax', line[:name])
          assert_equal('sales_tax', line[:type])
          assert_equal(1, line[:quantity])
          assert_equal(112, line[:unit_price])
          assert_equal(112, line[:total_amount])

          line = result[:order_lines].fifth
          assert_equal('Store Credit', line[:name])
          assert_equal('store_credit', line[:type])
          assert_equal(1, line[:quantity])
          assert_equal(-300, line[:unit_price])
          assert_equal(-300, line[:total_amount])
          assert_nil(line[:total_tax_amount])
          assert_nil(line[:tax_rate])

          assert_equal('22 S. 3rd St.', result[:billing_address][:street_address])
          assert_equal('22 S. 3rd St.', result[:shipping_address][:street_address])
          assert_includes(result[:merchant_urls][:confirmation], '/checkout/confirmation')
          assert_equal(@order.id, result[:merchant_reference1])
        end

        def test_to_h_for_eur
          @payment.set_address(supported_eur_address)
          @shipping.set_address(supported_eur_address)

          price_order

          result = Order.new(@order).to_h
          assert(result.present?)

          assert_equal('DE', result[:purchase_country])
          assert_equal('USD', result[:purchase_currency])
          assert_equal(1444, result[:order_amount])
          assert_equal(144, result[:order_tax_amount])

          assert_equal(4, result[:order_lines].size)

          line = result[:order_lines].first
          assert_equal('Integration Product', line[:name])
          assert_equal('physical', line[:type])
          assert_equal('SKU', line[:reference])
          assert_equal(2, line[:quantity])
          assert_equal(500, line[:unit_price])
          assert_equal(1000, line[:total_amount])
          assert_equal(81, line[:total_tax_amount])
          assert_equal(800, line[:tax_rate])
          assert_includes(line[:product_url], '/products/integration-product')
          assert_equal('Home > Pants', line[:product_identifiers][:category_path])

          line = result[:order_lines].second
          assert_equal('Shipping', line[:name])
          assert_equal('shipping_fee', line[:type])
          assert_equal(1, line[:quantity])
          assert_equal(700, line[:unit_price])
          assert_equal(700, line[:total_amount])
          assert_equal(63, line[:total_tax_amount])
          assert_equal(900, line[:tax_rate])

          line = result[:order_lines].third
          assert_equal('Order Discounts', line[:name])
          assert_equal('discount', line[:type])
          assert_equal(1, line[:quantity])
          assert_equal(-100, line[:unit_price])
          assert_equal(-100, line[:total_amount])
          assert_equal(0, line[:total_tax_amount])
          assert_equal(0, line[:tax_rate])

          line = result[:order_lines].fourth
          assert_equal('Store Credit', line[:name])
          assert_equal('store_credit', line[:type])
          assert_equal(1, line[:quantity])
          assert_equal(-300, line[:unit_price])
          assert_equal(-300, line[:total_amount])
          assert_equal(0, line[:total_tax_amount])
          assert_equal(0, line[:tax_rate])

          assert_equal('Augsburger Str. 36', result[:billing_address][:street_address])
          assert_equal('Augsburger Str. 36', result[:shipping_address][:street_address])
          assert_includes(result[:merchant_urls][:confirmation], '/checkout/confirmation')
          assert_equal(@order.id, result[:merchant_reference1])
        end
      end
    end
  end
end
