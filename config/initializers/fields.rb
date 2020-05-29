Workarea::Configuration.define_fields do
  fieldset 'Klarna', namespaced: false do
    # Klarna credentials can be configured via environment variables:
    #   WORKAREA_KLARNA_USERNAME
    #   WORKAREA_KLARNA_PASSWORD
    #
    # via rails credentials:
    #   klarna:
    #     username: YOUR_USERNAME
    #     password: YOUR_CLIENT_SECRET
    #
    # Or through the workarea admin configuration. Setting credentials through
    # the configuration allows for dyanmically changing credentials if, for
    # example, you are using the multi-site plugin and wish to use different
    # Klarna accounts for some or all sites.
    #
    field 'Username',
      type: :string,
      id: 'klarna_username',
      description: 'Your Klarna API username'
    field 'Password',
      type: :string,
      id: 'klarna_password',
      encrypted: true,
      description: 'Your Klarna API password'
  end
end
