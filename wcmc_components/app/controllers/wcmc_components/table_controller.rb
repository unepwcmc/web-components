module WcmcComponents
  class TableController < ApplicationController
    def index
      @results = table_class.paginate_for_table(**table_params_with_symbol_keys)

      render json: @results
    end

    def show
      @table_resource = get_table_resource(params[:id])
    end

    def new
      @table_resource = table_class.new
    end

    def create
      @table_resource = table_class.new
      @table_resource.update(modify_params)

      if @table_resource.save
        redirect_to table_path(@table_resource)
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      # Identify the resource
      @table_resource = get_table_resource(params[:id])
    end

    def update
      # Identify the resource
      @table_resource = get_table_resource(params[:id])
      # Update the resource
      if @table_resource.update(modify_params)
        # Redirect (to the show page/index page)
        redirect_to table_path(@table_resource)
      else
        render :edit, status: :unprocessable_entity
      end
    end

    private

    # Returns the class that corresponds to this table
    def table_class
      # Get the path
      path = request.fullpath

      # Get all registered paths which "match" our path. E.g., the ones that `path` begins with
      matching_paths = WcmcComponents.routes_classes.keys.select { |defined_route| path.starts_with? defined_route }

      # The longest of those is the most precise match.
      # Get the value it stores in routes_classes and return it as a constant
      WcmcComponents&.routes_classes&.dig(matching_paths.max)&.constantize
    end

    def modify_params
      params.require(:table).permit(
        *@table_resource.form_attributes.keys
      )
    end

    def table_params
      params.require(:table).permit(
        requested_page: Numeric,
        items_per_page: Numeric,
        filters: [],
        sort: %i[column ascending]
      )
    end

    # Double splat syntax (**) when passing an options hash to a method only works when a hash's keys are symbols
    # This method just returns params but in a form that is compatible with double splat syntax
    def table_params_with_symbol_keys
      table_params.to_h.deep_transform_keys(&:to_sym)
    end

    def get_table_resource(id)
      table_class.find(id)
    end
  end
end
