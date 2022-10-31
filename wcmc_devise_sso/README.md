# WcmcDeviseSso
This gem extends the devise functionality to quickly setup SSO using Microsoft Azure in a rails project.

## Usage
Note you will need to add the following to your Rails credentials:

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

```
rails generate wcmc_devise_sso
```

You will also need to update the `default_url_options` in the environment files within `config/environments/` which will have the dummy host 'http://TODO_PUT_YOUR_DOMAIN_HERE' for staging and production. If you are not using 'http://localhost:3000' for development, this will also need updating.

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
