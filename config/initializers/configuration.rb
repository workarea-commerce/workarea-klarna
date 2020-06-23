Workarea.configure do |config|
  config.tender_types << 'klarna'

  config.klarn_session_expiration = 48.hours
  config.klarna_playground = !Rails.env.production?
  config.klarna_continent_prefixes = {
    'Europe' => 'api',
    'North America' => 'api-na',
    'Oceania' => 'api-oc',
    'Australia' => 'api-oc'
  }
end
