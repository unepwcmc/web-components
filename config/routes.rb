Rails.application.routes.draw do
  get 'styleguide_pp/index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "component#index"
  get 'component/:id', to: 'component#show', as: 'component'
  get 'styleguide', to: 'styleguide#index'
end
