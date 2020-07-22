require 'test_helper'

module Workarea
  class Checkout
    module Steps
      class KlarnaPaymentTest < TestCase
        setup :set_shipping_service, :set_product, :set_addresses

        def set_shipping_service
          create_shipping_service(
            name: 'Test',
            rates: [{ price: 5.to_m }],
            tax_code: '001'
          )
        end

        def set_product
          create_product(id: 'PROD')
        end

        def set_addresses
          address_params = {
            first_name:   'Ben',
            last_name:    'Crouse',
            street:       '22 S. 3rd St.',
            city:         'Philadelphia',
            region:       'PA',
            postal_code:  '19106',
            country:      'US',
            phone_number: '2159251800'
          }

          Addresses.new(checkout).update(
            shipping_address: address_params,
            billing_address: address_params
          )
        end

        def order
          @order ||= create_order(
            email: 'test@workarea.com',
            items: [{ product_id: 'PROD', sku: 'SKU' }]
          )
        end

        def checkout
          @checkout ||= Checkout.new(order)
        end

        def payment
          @payment ||= checkout.payment
        end

        def step
          @step ||= Checkout::Steps::Payment.new(checkout)
        end

        def test_setting_klarna_tender
          assert(
            step.update(
              payment: 'klarna_pay_later',
              klarna: { authorization_token: '123' }
            )
          )

          assert(payment.klarna.present?)
          assert(payment.klarna.amount)
          assert(payment.klarna.authorization_token.present?)

          step.update
          assert(payment.klarna.nil?)

          payment.address = nil
          refute(step.update)
        end
      end
    end
  end
end
