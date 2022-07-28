WcmcComponents::Engine.routes.draw do
  scope module: 'table' do
    post '/', action: 'index'

    scope controller: 'download' do
      post '/download', action: 'index'
    end
  end
end
