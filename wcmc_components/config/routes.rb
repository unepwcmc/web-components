WcmcComponents::Engine.routes.draw do
  scope module: 'table' do
    post '/', action: 'index'
    get '/:id/edit', action: 'edit'
    post '/:id/update', action: 'edit'

    scope controller: 'download' do
      post '/download', action: 'index'
      post '/', to: 'table#list'
      post '/download', to: 'table#download'
    end
  end

  namespace :api do
    namespace :v1 do
      post '/', action: :index
    end
  end
end
