Workarea::Plugin.append_partials(
  'storefront.javascript',
  'workarea/storefront/klarna/sdk'
)

Workarea::Plugin.append_javascripts(
  'storefront.modules',
  'workarea/storefront/klarna/modules/klarna_widget'
)
