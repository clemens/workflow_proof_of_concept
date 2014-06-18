Rails.application.routes.draw do
  put 'orders/transition', to: 'orders#transition', as: :transition_order
  resources :orders

  root to: 'application#index'
end
