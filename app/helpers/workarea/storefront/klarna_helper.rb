module Workarea
  module Storefront
    module KlarnaHelper
      def klarna_on_site_messaging_javacript_tag
        return unless Workarea::Klarna.on_site_messaging?

        javascript_include_tag(
          klarna_on_site_messaging_url,
          async: true,
          data: {
            client_id:  Workarea::Klarna.on_site_messaging_client_id,
            klarna_on_site_messaging: ''
          }
        )
      end

      def klarna_on_site_messaging_url
        region = Workarea.config.klarna_on_site_messaging_region
        subdomains = [
          Workarea.config.klarna_on_site_messaging_subdomains[region],
          ('playground' if Workarea.config.klarna_playground)
        ]

        "https://#{subdomains.compact.join('.')}.klarnaservices.com/lib.js"
      end
    end
  end
end
