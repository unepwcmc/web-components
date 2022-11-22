MAILER_OPTIONS_DEVELOPMENT = <<-RUBY
  config.action_mailer.default_url_options = { host: "http://localhost:3000" }
RUBY

MAILER_OPTIONS_PRODUCTION = <<-RUBY
  config.action_mailer.default_url_options = { host: "http://TODO_PUT_YOUR_DOMAIN_HERE" }
RUBY

CREATE_FROM_PROVIDER_DATA_METHOD = <<-RUBY

  def self.create_from_provider_data(provider_data)
    where(provider: provider_data.provider, uid: provider_data.uid).first_or_create do |user|
      user.email = provider_data.info.email
      user.password = Devise.friendly_token[0, 20]
      user.wcmc!
    end
  end
RUBY

USER_ROLES_ENUM_DECLARATION = <<-RUBY

  enum role: { generic: 0, wcmc: 1 }

RUBY

OMNIAUTH_CONFIG = <<-RUBY
  config.omniauth :azure_activedirectory_v2,
    client_id: Rails.application.credentials.sso[:azure_client_id],
    client_secret: Rails.application.credentials.sso[:azure_client_secret],
    tenant_id: Rails.application.credentials.sso[:azure_tenant_id]
RUBY

OMNIAUTH_ROUTES_CONFIG = <<-RUBY
,
    controllers: {
      omniauth_callbacks: 'users/omniauth_callbacks'
    }
RUBY

README_LINES = <<-MARKDOWN

### Azure SSO credentials
Add the following from Lastpass to your credentials:
```
azure_client_id:
azure_client_secret:
azure_tenant_id:
```
MARKDOWN

class WcmcDeviseSsoGenerator < Rails::Generators::Base
  desc 'This generator installs devise and configures it for SSO authentication'

  source_root File.expand_path('../templates', __dir__)

  def install_devise
    unless yes?("Is Devise already installed?")
      generate 'devise:install'

      inject_into_file 'config/environments/development.rb',
        MAILER_OPTIONS_DEVELOPMENT,
        after: "Rails.application.configure do\n"

      %w(staging production).each do |env|
        inject_into_file "config/environments/#{env}.rb",
          MAILER_OPTIONS_PRODUCTION,
          after: "Rails.application.configure do\n"
      end

      generate 'devise USER'

      inject_into_class 'app/models/user.rb',
        'User',
        "  extend Devise::Models\n"

      rake 'db:migrate'
    end
  end

  def add_devise_views
    if yes?('Would you like to generate devise views?')
      generate 'devise:views'
    end
  end

  def create_omniauth_callbacks_controller
    copy_file 'omniauth_callbacks_controller.rb',
      'app/controllers/users/omniauth_callbacks_controller.rb'
  end

  def configure_user_model_for_omniauth
    # TODO: make more robust, if validatable is not there?
    devise_omniauth_param_str = ", :omniauthable, omniauth_providers: %i[azure_activedirectory_v2]\n"

    inject_into_file 'app/models/user.rb',
      devise_omniauth_param_str,
      after: ':validatable'

    inject_into_file 'app/models/user.rb',
      CREATE_FROM_PROVIDER_DATA_METHOD,
      after: devise_omniauth_param_str
  end

  def configure_devise_initializer_for_omniauth
    gsub_file 'config/initializers/devise.rb',
      'please-change-me-at-config-initializers-devise@example.com',
      'no-reply@unep-wcmc.org'

    omniauth_comment = "# config.omniauth :github, 'APP_ID', 'APP_SECRET', scope: 'user,public_repo'\n"

    inject_into_file 'config/initializers/devise.rb',
      OMNIAUTH_CONFIG,
      after: omniauth_comment
  end

  def configure_routes_for_omniauth
    inject_into_file 'config/routes.rb',
      OMNIAUTH_ROUTES_CONFIG,
      after: 'devise_for :users'
  end

  def add_user_roles_enum_to_model
    inject_into_file 'app/models/user.rb',
      USER_ROLES_ENUM_DECLARATION,
      after: 'extend Devise::Models'
  end

  def add_sign_in_strategy_migration
    filename = 'add_sso_attributes_to_users.rb'
    timestamp = Time.now.strftime('%Y%m%d%H%M%S')

    copy_file filename, "db/migrate/#{timestamp}_#{filename}"
  end

  def run_migration
    rake 'db:migrate'
  end

  def add_to_readme
    file = 'README.md'

    if File.file?(file)
      append_to_file file, README_LINES
    else
      create_file file, README_LINES 
    end
  end
end