Workarea::Plugin.append_partials(
  'storefront.javascript',
  'workarea/storefront/klarna/sdk'
)

Workarea::Plugin.append_partials(
  'storefront.body_top',
  'workarea/storefront/klarna/on_site_messaging'
)

Workarea::Plugin.append_partials(
  'storefront.payment_method',
  'workarea/storefront/checkouts/klarna_payments'
)

Workarea::Plugin.append_partials(
  'storefront.product_details',
  'workarea/storefront/products/klarna_placement'
)

Workarea::Plugin.append_partials(
  'storefront.footer_help',
  'workarea/storefront/klarna/footer_link'
)

Workarea::Plugin.append_javascripts(
  'storefront.modules',
  'workarea/storefront/klarna/modules/klarna_widget',
  'workarea/storefront/klarna/modules/klarna_placement_refresh'
)
