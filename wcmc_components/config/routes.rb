WcmcComponents::Engine.routes.draw do
  post '/', to: 'table#list'
  post '/download', to: 'table#download'
  namespace :api do
    namespace :v1 do
      post '/', to: 'api#list'
    end
  end
end
