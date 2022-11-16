module WcmcComponents
  class TableController < ApplicationController
    before_action :authenticate_admin_user, except: [:index, :show]

    def index
      @results = model_class.paginate_for_table(query_params_with_symbol_keys)

      render json: @results
    end

    def show
      @table_resource = model_class.find(params[:id])
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

      if @table_resource.update({archived: archive_params == '1'})
        render json: @table_resource.to_json
      else
        render :archive, status: :unprocessable_entity
      end
    end

    private

    # Authenticate admin user role
    # Requires devise and role enum on User with type wcmc (or other implementation of the methods wcmc and current_user)
    # Compatiable with wcmc_devise_sso
    def authenticate_admin_user
      redirect_path = defined?(new_user_session_path) ? new_user_session_path : '/'
      user = defined?(current_user) ? current_user : nil

      # Update this method to include any additional user roles that can create/update/archive
      is_admin = user && defined?(user.wcmc) && user.wcmc

      redirect_to redirect_path unless is_admin
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
