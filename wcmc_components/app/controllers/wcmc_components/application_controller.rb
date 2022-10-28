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

    # Double splat syntax (**) when passing an options hash to a method only works when a hash's keys are symbols
    # This method just returns params but in a form that is compatible with double splat syntax
    def query_params_with_symbol_keys
      query_params.to_h.deep_transform_keys(&:to_sym)
    end

    def query_params
      params.permit(
        :requested_page,
        :items_per_page,
        filters: [:name, :type, options: []],
        sort: %i[column ascending]
      )
    end
  end
end
