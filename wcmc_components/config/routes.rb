WcmcComponents::Engine.routes.draw do
  resources :table, except: [:index, :create],  path: ''
  
  scope module: 'table' do
    post '/', action: 'index'
    post '/create', action: 'create', as: :create

    scope controller: 'download' do
      post '/download', action: 'index'
    end
  end
end
