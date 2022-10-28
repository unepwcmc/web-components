module WcmcComponents
  class TableController < ApplicationController
    def index
      @results = model_class.paginate_for_table(**table_params_with_symbol_keys)

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

    private

    def table_params
      params.permit(
        :requested_page,
        :items_per_page,
        filters: [:name, :type, options: []],
        sort: %i[column ascending]
      )
    end

    # Double splat syntax (**) when passing an options hash to a method only works when a hash's keys are symbols
    # This method just returns params but in a form that is compatible with double splat syntax
    def table_params_with_symbol_keys
      table_params.to_h.deep_transform_keys(&:to_sym)
    end
  end
end
