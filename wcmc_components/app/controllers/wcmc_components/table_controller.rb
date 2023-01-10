module WcmcComponents
  class TableController < WcmcComponents::ApplicationController
    skip_before_action :verify_authenticity_token

    before_action :authenticate_admin_user, except: [:index, :show]

    def index
      @results = model_class.paginate_for_table(
        query_params_with_symbol_keys.merge(is_admin: @is_admin)
      )

      render json: @results
    end

    def show
      @table_resource = model_class.find(params[:id])

      if @table_resource.archived? && !@is_admin
        redirect_to_sign_in
      end
    end

    def new
      @table_resource = model_class.new
    end

    def create
      @table_resource = model_class.new
      @table_resource.update(modify_params)

      if @table_resource.save
        redirect_to table_path(@table_resource)
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      # Identify the resource
      @table_resource = model_class.find(params[:id])
    end

    def update
      # Identify the resource
      @table_resource = model_class.find(params[:id])
      # Update the resource
      if @table_resource.update(modify_params)
        # Redirect (to the show page/index page)
        redirect_to table_path(@table_resource)
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def archive
      @table_resource = model_class.find(params[:id])

      if @table_resource.update({archived: archive_params == 1})
        render json: @table_resource.to_json
      else
        render :archive, status: :unprocessable_entity
      end
    end

    private
    
    def authenticate_admin_user
      redirect_to_sign_in unless @is_admin
    end

    def redirect_to_sign_in
      redirect_path = defined?(new_user_session_path) ? new_user_session_path : '/'

      redirect_to redirect_path
    end

    def archive_params
      params.require(:archived)
    end
  
    def modify_params
      params.require(:table).permit(
        *@table_resource.form_attributes.keys
      )
    end
  end
end
