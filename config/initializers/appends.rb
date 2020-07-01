Workarea::Plugin.append_partials(
  'storefront.javascript',
  'workarea/storefront/klarna/sdk'
)

Workarea::Plugin.append_partials(
  'storefront.payment_method',
  'workarea/storefront/checkouts/klarna_payments'
)

Workarea::Plugin.append_javascripts(
  'storefront.modules',
  'workarea/storefront/klarna/modules/klarna_widget'
)
