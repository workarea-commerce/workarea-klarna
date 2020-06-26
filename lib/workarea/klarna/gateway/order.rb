module Workarea
  module Klarna
    class Gateway
      class Order
        attr_reader :order

        def initialize(order, payment: nil, shippings: shippings)
          @order = order
          @payment = payment
          @shippings = shippings
        end

        def to_h
          {
            purchase_country: payment.address.country.alpha2,
            purchase_currency: order.total_price.currency.iso_code,
            locale: I18n.locale,
            order_amount: order.total_price.cents,
            order_tax_amount: order.tax_total.cents,
            order_lines: order_lines,
            billing_address: billing_address,
            shipping_address: shipping_address,
            merchant_urls: merchant_urls,
            merchant_reference1: order.id
          }
            .compact
            .tap { |hash| remove_inline_tax(hash) if include_tax_line? }
        end

        def payment
          @payment ||= Workarea::Payment.find(order.id)
        end

        def shippings
          @shippings ||= Workarea::Shipping.by_order(order.id)
        end

        def price_adjustments
          @price_adjustments ||=
            order.price_adjustments + shippings.flat_map(&:price_adjustments)
        end

        private

        def order_lines
          [
            *order.items.map(&method(:format_item)),
            shipping_line,
            discount_line,
            tax_line
          ].compact
        end

        def billing_address
          format_address(payment.address)
        end

        def shipping_address
          format_address(shippings.first.address)
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
          tax_amount, tax_rate = item_tax_data(item)

          {
            name: view_model.product_name,
            type: item.shipping? ? 'physical' : 'digital',
            reference: item.sku,
            quantity: item.quantity,
            unit_price: item.current_unit_price.cents,
            total_amount: item.total_price.cents,
            total_tax_amount: tax_amount,
            tax_rate: tax_rate,
            product_url: Workarea::Storefront::Engine.routes.url_helpers.product_url(
              host: Workarea.config.host,
              id: view_model.product.slug
            ),
            product_identifiers: { category_path: breadcrumbs&.join(' > ') }.compact
          }
        end

        def item_tax_data(item)
          tax_amount =
            price_adjustments
              .adjusting('tax')
              .select { |pa| pa.data['order_item_id'].to_s == item.id.to_s }
              .sum(&:amount)

          tax_rate = (tax_amount.cents * 1.0 / item.total_price.cents).round(2) * 10000

          [tax_amount.cents, tax_rate.to_i]
        end

        def shipping_line
          return unless shippings.present? && shippings.all?(&:shipping_service)

          shipping_total = order.shipping_total.cents
          shipping_tax = price_adjustments
                          .adjusting('tax')
                          .select { |pa| !!pa.data['shipping_service_tax'] }
                          .sum(&:amount)
                          .cents

          {
            name: 'Shipping',
            type: 'shipping_fee',
            quantity: 1,
            unit_price: shipping_total,
            total_amount: shipping_total,
            total_tax_amount: shipping_tax,
            tax_rate: ((shipping_tax * 1.0 / shipping_total).round(2) * 10000).to_i
          }
        end

        def discount_line
          order_discount = price_adjustments.adjusting('order').discounts.sum.cents
          return if order_discount.zero?

          {
            name: 'Order Discounts',
            type: 'discount',
            quantity: 1,
            unit_price: order_discount,
            total_amount: order_discount,
            total_tax_amount: 0,
            tax_rate: 0
          }
        end

        def tax_line
          return unless include_tax_line?

          {
            name: 'Tax',
            type: 'sales_tax',
            quantity: 1,
            unit_price: order.tax_total.cents,
            total_amount: order.tax_total.cents
          }
        end

        def include_tax_line?
          payment.address.country.alpha2 == 'US'
        end

        def remove_inline_tax(hash)
          hash[:order_lines].each do |line|
            line.delete(:total_tax_amount)
            line.delete(:tax_rate)
          end
        end

        def merchant_urls
          {
            confirmation:
              Workarea::Storefront::Engine
                .routes
                .url_helpers
                .checkout_confirmation_url(
                  host: Workarea.config.host
                )
          }
        end
      end
    end
  end
end