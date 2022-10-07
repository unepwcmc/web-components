WcmcComponents::Engine.routes.draw do
  resources :table, path: ''
  
  scope module: 'table' do
    scope controller: 'download' do
      post '/download', action: 'index'
    end
  end
end
