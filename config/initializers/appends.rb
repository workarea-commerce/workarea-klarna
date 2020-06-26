Workarea::Plugin.append_partials(
  'storefront.javascript',
  'workarea/storefront/klarna/sdk'
)

Workarea::Plugin.append_partials(
  'storefront.checkout_payment_top',
  'workarea/storefront/checkouts/klarna_session'
)

Workarea::Plugin.append_partials(
  'storefront.payment_method',
  'workarea/storefront/checkouts/klarna_payments'
)

Workarea::Plugin.append_javascripts(
  'storefront.modules',
  'workarea/storefront/klarna/modules/klarna_widget'
)
