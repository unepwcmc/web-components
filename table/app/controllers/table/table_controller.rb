module Table
  class TableController < ApplicationController

    def table_class
      Table.routes_classes[request.fullpath].constantize
    end
    
    def list
      @results = table_class.paginate(params.to_json)
      render json: @results
    end
  end
end
