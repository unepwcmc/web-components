class DeviseSsoGenerator < Rails::Generators::Base
    desc 'This generator installs devise and configures it for SSO authentication'

    source_root File.expand_path('../templates', __dir__)

    def install_devise
      unless yes?("Is Devise already installed?")
        generate 'devise:install'

        inject_into_file 'config/environments/development.rb',
          after: "Rails.application.configure do\n" do
<<-RUBY
  config.action_mailer.default_url_options = { host: "http://localhost:3000" }
RUBY
        end

        %w(staging production).each do |env|
          inject_into_file "config/environments/#{env}.rb",
            after: "Rails.application.configure do\n" do
<<-RUBY
  config.action_mailer.default_url_options = { host: "http://TODO_PUT_YOUR_DOMAIN_HERE" }
RUBY
          end
        end

        generate 'devise USER'

        inject_into_class 'app/models/user.rb', 'User', "  extend Devise::Models\n"

        rake 'db:migrate'
      end

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

      inject_into_file 'app/models/user.rb', after: ':validatable' do
        devise_omniauth_param_str
      end

      inject_into_file 'app/models/user.rb', after: devise_omniauth_param_str do
<<-RUBY

  def self.create_from_provider_data(provider_data)
    where(provider: provider_data.provider, uid: provider_data.uid).first_or_create  do |user|
      user.email = provider_data.info.email
      user.password = Devise.friendly_token[0, 20]
    end
  end
RUBY
      end
    end

    def configure_devise_initializer_for_omniauth
      gsub_file 'config/initializers/devise.rb',
        'please-change-me-at-config-initializers-devise@example.com',
        'no-reply@unep-wcmc.org'

      omniauth_comment = "# config.omniauth :github, 'APP_ID', 'APP_SECRET', scope: 'user,public_repo'\n"

      inject_into_file 'config/initializers/devise.rb', after: omniauth_comment do
<<-RUBY
  config.omniauth :azure_activedirectory_v2,
    client_id: Rails.application.credentials.sso[:azure_client_id],
    client_secret: Rails.application.credentials.sso[:azure_client_secret],
    tenant_id: Rails.application.credentials.sso[:azure_tenant_id]
RUBY
      end
    end

    def configure_routes_for_omniauth
      inject_into_file 'config/routes.rb', after: 'devise_for :users' do
<<-RUBY
,
    controllers: {
      omniauth_callbacks: 'users/omniauth_callbacks'
    }
RUBY
      end
    end

    def add_sign_in_strategy_migration
      filename = 'add_sign_in_strategy_attributes_to_users.rb'
      timestamp = Time.now.strftime('%Y%m%d%H%M%S')

      copy_file filename, "db/migrate/#{timestamp}_#{filename}"
    end

    def run_migration
      rake 'db:migrate'
    end

    def add_to_readme
      file = 'README.md'
      readme_lines = 
<<-MARKDOWN

### Azure SSO credentials
Add the following from Lastpass to your credentials:
```
azure_client_id:
azure_client_secret:
azure_tenant_id:
```
MARKDOWN
      if File.file?(file)
        append_to_file file, readme_lines
      else
        create_file file, readme_lines 
      end
    end
  end