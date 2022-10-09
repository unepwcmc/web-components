WcmcComponents::Engine.routes.draw do
  resources :table, except: [:index, :create],  path: '' do
    post 'archive', on: :member
  end
  
  scope module: 'table' do
    post '/', action: 'index'
    post '/create', action: 'create', as: :create_table

    scope controller: 'download' do
      post '/download', action: 'index'
    end
  end
end
