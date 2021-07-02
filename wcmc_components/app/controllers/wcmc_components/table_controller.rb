module WcmcComponents
  class TableController < ApplicationController

    def table_class
      WcmcComponents.routes_classes[request.fullpath].constantize
    end
    
    def list
      @results = table_class.paginate(params.to_json)
      render json: @results
    end
  end
end
