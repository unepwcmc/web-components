module WcmcComponents
  class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception

    private

    def model_class
      # Get the path
      path = request.fullpath

      # Get all registered paths which "match" our path. E.g., the ones that `path` begins with
      matching_paths = WcmcComponents.routes_classes.keys.select { |defined_route| path.starts_with? defined_route }

      # The longest of those is the most precise match.
      # Get the value it stores in routes_classes and return it as a constant
      WcmcComponents&.routes_classes&.dig(matching_paths.max)&.constantize
    end
  end
end
