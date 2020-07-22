module Workarea
  module Factories
    module Klarna
      Factories.add(self)

      def configure_klarna_countries
        Workarea.configure do |config|
          config.countries << Country['DE'] # Germany
          config.countries << Country['NZ'] # New Zealand
          config.countries << Country['BR'] # Brazil
        end
      end

      def german_address
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

      def kiwi_address
        {
          first_name: 'Ronald',
          last_name: 'King',
          street: '10-18 Adelaide Road',
          postal_code: '6021',
          city: 'Mount Cook',
          region: 'WGN',
          country: 'NZ'
        }
      end

      def brazilian_address
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
