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
    end
  end
end
