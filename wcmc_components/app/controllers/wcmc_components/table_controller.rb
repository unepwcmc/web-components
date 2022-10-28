module WcmcComponents
  class TableController < ApplicationController
    def index
      @results = model_class.paginate_for_table(query_params_with_symbol_keys)

      render json: @results
    end

    def edit
      # Identify the resource
      @table_resource = model_class.find(params[:id])
      # render the form
      render :edit
    end

    def update
      # Identify the resource
      @table_resource = model_class.find(params[:id])
      
      # Update the resource
      @table_resource.update(modify_params)
      
      # Redirect (to the show page/index page)
      redirect_to "/"
    end

    private
  
    def modify_params
      params.require(:table).permit(
        *@table_resource.form_attributes.keys
      )
    end
  end
end
