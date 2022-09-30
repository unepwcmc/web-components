WcmcComponents::Engine.routes.draw do
  devise_for :users, class_name: "WcmcComponents::User", module: :devise
  scope module: 'table' do
    post '/', action: 'index'
    get '/:id/edit', action: 'edit'
    put '/:id/update', action: 'update'

    scope controller: 'download' do
      post '/download', action: 'index'
    end
  end
end
