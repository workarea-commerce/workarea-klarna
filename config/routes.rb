Workarea::Storefront::Engine.routes.draw do
  scope '(:locale)', constraints: Workarea::I18n.routes_constraint do
    get 'klarna', to: 'pages#klarna'
  end
end
