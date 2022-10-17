class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

    def azure_activedirectory_v2
      response_params = request.env['omniauth.auth']
      @user = User.create_from_provider_data(response_params)
  
      if @user&.persisted?
        sign_in_and_redirect @user
        set_flash_message(:notice, :success, kind: 'Azure AD') if is_navigational_format?
      else
        flash[:danger] = 'You do not have an account!'
        redirect_back(fallback_location: root_path)
      end
    end
  end