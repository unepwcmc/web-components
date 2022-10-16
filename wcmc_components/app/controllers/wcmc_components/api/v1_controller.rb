module WcmcComponents
  class Api::V1Controller < ApplicationController
    def index
      render json: model_class.paginate_api(params.to_json)
    end
  end
end