module WcmcComponents
  class ApplicationController < ActionController::Base
    # protect_from_forgery with: :exception
    skip_before_action :verify_authenticity_token

    private

    def model_class
      # walk up url to find which class table we are in
      path = request.fullpath
      until path.nil?
        if !WcmcComponents.routes_classes[path].nil?
          return WcmcComponents.routes_classes[path].constantize
        elsif !path.rindex('/').nil?
          path = path[0, path.rindex('/')]
        end
      end
    end
  end
end
