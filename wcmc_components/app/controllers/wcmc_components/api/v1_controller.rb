module WcmcComponents
  class Api::V1Controller < WcmcComponents::ApplicationController
    skip_before_action :verify_authenticity_token

    def index
      render json: model_class.paginate_for_api(query_params_with_symbol_keys)
    end
  end
end