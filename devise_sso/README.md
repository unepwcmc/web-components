# DeviseSso
This gem extends the devise functionality to quickly setup SSO using Microsoft Azure in a rails project.

## Usage
How to use my plugin.

Note you will need to add the following to your Rails credentials:

```
azure_client_id:
azure_client_secret:
azure_tenant_id:
```

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'devise_sso'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install devise_sso
```

Then install devise and generate the required views and config.

```
rails generate wcmc_wcmc_devise_sso
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
