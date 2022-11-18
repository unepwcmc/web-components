module WcmcComponents
  class TableController < WcmcComponents::ApplicationController
    def index
      @results = model_class.paginate_for_table(query_params_with_symbol_keys)
      render json: @results
    end

    def edit
      # Identify the resource
      @table_resource = model_class.find(params[:id])
      # render the form
    end

    # def update
    #   # Identify the resource
    #   @table_resource = model_class.find(params[:id])
    #   # Update the resource
    #   @table_resource.update(table_params)
    #   # Redirect (to the show page/index page)
    # end
  end
end
