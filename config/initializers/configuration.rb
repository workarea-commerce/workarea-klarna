Workarea.configure do |config|
  config.tender_types << 'klarna'

  # If this is false, the javascript file will not be included on the
  # storefront, and a bogus gateway will be used.
  config.load_klarna = !Rails.env.test?

  # How long a klarna session is valid for. This is defined by Klarna's API
  # and should not be extended beyond 48 hours.
  config.klarn_session_expiration = 48.hours

  # This controls whether requests go to the live or sandbox API endpoints.
  config.klarna_playground = !Rails.env.production?

  # Continents supported by KLarna and keys used to generate paths to
  # credentials via environment variables and/or rails credentials. Also used
  # to get the keys for the subdomain configuration.
  config.klarna_continent_keys = {
    'Europe' => 'EUR',
    'North America' => 'NA',
    'Oceania' => 'OC',
    'Australia' => 'AUS'
  }

  # Subdomains to use for API requests depending on the user's continent.
  config.klarna_subdomains = {
    'EUR' => 'api',
    'NA' => 'api-na',
    'OC' => 'api-oc',
    'AUS' => 'api-oc'
  }
end
