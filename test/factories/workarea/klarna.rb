module Workarea
  module Factories
    module Klarna
      Factories.add(self)

      def create_klarna_session(overrides = {})
        attributes = {
          session_id: SecureRandom.hex(10),
          client_token: SecureRandom.hex(10),
          payment_method_categories: [
            { name: 'Pay in 30 days', identifier: 'pay_later' }
          ]
        }.merge(overrides)

        Workarea::Payment::KlarnaSession.create!(attributes)
      end

      def klarna_gateway_class
        if Workarea.config.load_klarna
          Workarea::Klarna::Gateway
        else
          Workarea::Klarna::BogusGateway
        end
      end

      def configure_klarna_data
        Workarea.configure do |config|
          config.countries << Country['DE'] # Germany
          config.countries << Country['BR'] # Brazil
          config.klarna_na_username = 'na_user'
          config.klarna_na_password = 'na_password'
          config.klarna_eur_username = 'eur_user'
          config.klarna_eur_password = 'eur_password'
        end
      end

      def supported_na_address
        factory_defaults :shipping_address
      end

      def supported_eur_address
        {
          first_name: 'Ragnall',
          last_name: 'Koch',
          street: 'Augsburger Str. 36',
          postal_code: '82110',
          city: 'Germering',
          region: 'BY',
          country: 'DE'
        }
      end

      def unsupported_address
        {
          first_name: 'Ronaldo',
          last_name: 'Palhaco',
          street: 'R. Osvaldo Cruz, 1',
          street_2: 'Meireles',
          postal_code: '60125-150',
          city: 'Fortaleza',
          region: 'CE',
          country: 'BR'
        }
      end

      def create_supporting_data_for_klarna
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

        Workarea::Pricing.perform(@order, @shipping)
      end

      def create_klarna_tender(payment: nil, **overrides)
        attributes = {
          authorization_token: '1111',
          payment_method_category: 'pay_later',
          amount: 14.12.to_m
        }.merge(overrides)

        payment ||= create_payment
        tender = payment.build_klarna(attributes)
        payment.save! && tender
      end
    end
  end
end
