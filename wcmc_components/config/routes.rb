WcmcComponents::Engine.routes.draw do
  scope module: 'table' do
    post '/', action: 'index'
    get '/:id/edit', action: 'edit', as: :edit
    put '/:id/update', action: 'update'

    scope controller: 'download' do
      post '/download', action: 'index'
    end
  end
end
