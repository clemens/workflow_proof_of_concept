Rails.application.routes.draw do
  put 'orders/transition', to: 'orders#transition', as: :transition_order
  resources :orders

  # RuoteKit routes
  match '/_ruote' => RuoteKit::Application, via: :any
  match '/_ruote/*path' => RuoteKit::Application, via: :any

  root to: 'application#index'
end
