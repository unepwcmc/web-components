module WcmcComponents
  class Api::V1Controller < ApplicationController
    skip_before_action :verify_authenticity_token

    def index
      render json: model_class.paginate_for_api(api_params_with_symbol_keys)
    end

    private

    def api_params
      params.permit(
        :requested_page,
        :items_per_page,
        filters: [],
        sort: %i[column ascending]
      )
    end

    # # Double splat syntax (**) when passing an options hash to a method only works when a hash's keys are symbols
    # # This method just returns params but in a form that is compatible with double splat syntax
    def api_params_with_symbol_keys
      api_params.to_h.deep_transform_keys(&:to_sym)
    end
  end
end