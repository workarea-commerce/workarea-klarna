Workarea::Configuration.define_fields do
  fieldset 'Klarna', namespaced: false do
    # Klarna credentials can be configured via environment variables per
    # continent:
    #   WORKAREA_KLARNA_EUR_USERNAME
    #   WORKAREA_KLARNA_EUR_PASSWORD
    #   WORKAREA_KLARNA_NA_USERNAME
    #   WORKAREA_KLARNA_NA_PASSWORD
    #
    # via rails credentials:
    #   klarna:
    #     eur:
    #       username: YOUR_USERNAME
    #       password: YOUR_CLIENT_SECRET
    #     na:
    #       username: YOUR_USERNAME
    #       password: YOUR_CLIENT_SECRET
    #
    # Or through the workarea admin configuration. Setting credentials through
    # the configuration allows for dyanmically changing credentials if, for
    # example, you are using the multi-site plugin and wish to use different
    # Klarna accounts for some or all sites.
    #
    field 'Europe Username',
      type: :string,
      id: 'klarna_eur_username',
      description: 'Your Klarna API username for Europe',
      allow_blank: true
    field 'Europe Password',
      type: :string,
      id: 'klarna_eur_password',
      encrypted: true,
      description: 'Your Klarna API password for Europe',
      allow_blank: true
    field 'North America Username',
      type: :string,
      id: 'klarna_na_username',
      description: 'Your Klarna API username for North America',
      allow_blank: true
    field 'North America Password',
      type: :string,
      id: 'klarna_na_password',
      encrypted: true,
      description: 'Your Klarna API password for North America',
      allow_blank: true

    field 'On-Site Messaging Client ID',
      type: :string,
      id: 'klarna_on_site_messaging_client_id',
      allow_blank: true,
      description: %{
        The client ID provided by Klarna when enabling On-Site Messaging in the
        Klarna merchant portal. See
        <a href="https://developers.klarna.com/documentation/on-site-messaging/integration/platform-activation/">the Klarna documentation</a>
        for more information.
      }.squish.html_safe

    field 'On-Site Messaging Region',
      type: :string,
      id: 'klarna_on_site_messaging_region',
      default: -> { Workarea.config.klarna_continent_keys.values.first },
      values: -> { Workarea.config.klarna_continent_keys.to_a },
      description: 'Region to use for contacting klarna for on-site messaging'
  end
end
