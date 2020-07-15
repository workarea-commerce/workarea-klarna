Workarea.configure do |config|
  config.tender_types << 'klarna'

  config.klarn_session_expiration = 48.hours
  config.klarna_playground = !Rails.env.production?

  config.klarna_continent_keys = {
    'Europe' => 'EUR',
    'North America' => 'NA',
    'Oceania' => 'OC',
    'Australia' => 'AUS'
  }

  config.klarna_subdomains = {
    'EUR' => 'api',
    'NA' => 'api-na',
    'OC' => 'api-oc',
    'AUS' => 'api-oc'
  }
end
