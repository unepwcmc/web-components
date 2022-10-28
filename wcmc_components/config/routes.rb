WcmcComponents::Engine.routes.draw do
  scope module: 'table' do
    post '/', action: 'index'
    get '/:id/edit', action: 'edit'
    put '/:id/update', action: 'update'

    scope controller: 'download' do
      post '/download', action: 'index'
    end
  end

  namespace :api do
    namespace :v1 do
      post '/', action: :index
    end
  end
end
