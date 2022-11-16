module WcmcComponents
  class Api::V1Controller < WcmcComponents::ApplicationController
    skip_before_action :verify_authenticity_token

    def index
      render json: model_class.paginate_api(params.to_json)
    end
  end
end