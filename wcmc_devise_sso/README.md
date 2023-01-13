# WcmcDeviseSso
This gem extends the devise functionality to quickly setup SSO using Microsoft Azure in a rails project.
It adds SSO to a user model or creates a new User class if there isn't one present.
You can sign in via SSO at ```/users/sign_in```.

## Usage
Note you will need to add the following to your Rails credentials from LastPass:

```
azure_client_id:
azure_client_secret:
azure_tenant_id:
```

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'wcmc_devise_sso'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install wcmc_devise_sso
```

Then install devise and generate the required views and config.

You may need to replace the ```link_to``` omniauth provider in the ```devise/shared/_links.html.erb``` to ```button_to``` so it makes a POST request instead of a GET request.

```
rails generate wcmc_devise_sso
```

You will also need to update the `default_url_options` in the environment files within `config/environments/` which will have the dummy host 'http://TODO_PUT_YOUR_DOMAIN_HERE' for staging and production. If you are not using 'http://localhost:3000' for development, this will also need updating.

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
