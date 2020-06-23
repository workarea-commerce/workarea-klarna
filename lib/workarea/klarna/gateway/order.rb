module Workarea
  module Klarna
    class Gateway
      class Order
        attr_reader :order

        def initialize(order, payment: nil)
          @order = order
          @payment = payment
        end

        def to_hash
          {
            purchase_country: payment.adress.country.alpha2,
            purchase_currency: order.total_price.currency.iso_code,
            locale: I18n.locale,
            order_amount: order.total_price.cents,
            order_tax_amount: order.tax_total.cents,
            order_lines: order.items.map(&method(:format_item)) + additional_lines,
            billing_address: billing_address,
            shipping_address: shipping_address,
            merchant_urls: { confirmation: '' },
            merchant_reference1: order.id
          }.compact
        end

        def payment
          @payment ||= Workarea::Payment.find(order.id)
        end

        def shipping
          @shipping ||= Workarea::Shipping.find_by_order(order.id)
        end

        private

        def billing_address
          format_address(payment.address)
        end

        def shipping_address
          format_address(shipping.address)
        end

        def format_address(address)
          return unless address.present?
          {
            given_name: address.first_name,
            family_name: address.last_name,
            email: order.email,
            street_address: address.street,
            street_address2: address.street_2,
            postal_code: address.postal_code,
            city: address.city,
            region: address.region,
            phone: address.phone_number,
            country: address.country.alpha2
          }
        end

        def format_item(item)
          view_model = Storefront::OrderItemViewModel.new(item)
          breadcrumbs = Navigation::Breadcrumbs.from_global_id(item.via) if item.via.present?

          {
            type: item.shipping? ? 'physical' : 'digital',
            reference: item.sku,
            name: view_model.product_name,
            quantity: item.quantity,
            unit_price: item.current_unit_price.cents,
            total_amount: item.total_price.cents,
            total_tax_amount: 0, # TODO
            product_url: Workarea::Storefront::Engine.routes.url_helpers.product_url(
              host: Workarea.config.host,
              id: item.product_id
            ),
            product_identifiers: { category_path: breadcrumbs&.join(' > ') }.compact
          }
        end

        def additional_lines
          lines = [
            {
              type: 'shipping_fee',
              quantity: 1,
              unit_price: order.shipping_total.cents,
              total_amount: order.shipping_total.cents,
              total_tax_amount: 0 # TODO
            }
          ]

          if payment.address.country.alpha2 == 'US'
            lines << {
              type: 'sales_tax',
              name: 'Tax',
              quantity: 1,
              unit_price: order.tax_total.cents,
              total_amount: order.tax_total.cents
            }
          end

          lines
        end
      end
    end
  end
end
