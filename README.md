# README (Style guide guide)

## Getting up and running
* bundle
* yarn install

Terminal 1:
* rails s

Terminal 2:
* webpack-dev-server

## Runnning Tests
Terminal 3:
* yarn test

This will run all tests in `**.spec.js` files contained within the `components` file.
The tests run using Jest and will re-run within the terminal on saved changes. Console logs are printed into the terminal.

If you are using imports from node_modules, make sure to add the modules (as exceptions) to transformIgnorePatterns in package.json, to make sure these are transpiled.

Also, if verbose is set to true for yarn test, often console logs are overwritten in the terminal when using --watchAll. Another solution to the missing logs is to do a single test run (remove --watchAll)

## How to Use the WcmcComponents Table Engine

### About the `WcmcComponents` gem

The WcmcComponents module has three sub-modules:

- **WcmcComponents::Filterable** can be included in an ActiveRecord class to provide it with methods to query the database and apply filters, sorting and serialization. Its main entrypoint is the `#paginate` method, which serves filtered, sorted data from that ActiveRecord class in the format expected by the FilterableTable component.
- **WcmcComponents::Loadable** provides the ability to import data into a DB table from a CSV. 
- **WcmcComponents::Engine** is a [Rails engine](https://guides.rubyonrails.org/engines.html) which can be mounted in a host application to automatically provide two new routes and controller actions, which can be seen in `wcmc_components/config/routes.rb`. Each mounted Engine provides a table route and a download route; the Engine can be mounted as many times as you like, but each requires registration in `config/initializers/wcmc_components.rb` as detailed below.

### Add gem(s) to spec

in Gemfile add either:

* gem 'wcmc-components', '~> 0.2.0', source: "https://gem-server.unep-wcmc.org/"

or to use local code cloned into web-components

* gem 'wcmc_components', path: '../web-components/wcmc_components'

### Decorate your model
In the model you want to display in a filter table add 

* include WcmcComponents::Filterable

and optionally configure columns using the table_column method, e.g.
*   table_column :created_at, title: 'First Date'

see app/models/country.rb as an example

### configure the engine

Mount the engine in your config/routes.rb by adding a line like:

*   mount WcmcComponents::Engine, at: "/countries", as: 'country_table'

Final step is to tell the engine which class to use for each mount point 
Create an intializer e.g. in config/initializers/table.rb containing the mappings 
```
WcmcComponents.routes_classes = {
  '/countries/' => 'Country',
  '/meas/' => 'Mea'
}

WcmcComponents.classes_show_page_format = {
  'Country' => '/country/%d/',
  'Mea' => '/moreComplicated/%d/format'
}
```

TODO: I think I should be able to figure these mappings automagically from the mount line but can't make this work (yet!)
Have now added a config for where the 'show' page url should be - this also might be able to be pulled out of routes with a bit of patience

### Create migrations
TODO - improve these docs and provide examples in this repo
- Create a migration for your CSV
- Create a join table migration for fields with multiple values

### Create rake tasks
TODO - improve these docs and provide examples in this repo
You will need to create a rake task that imports the CSV.
See tradehub-navigator repo for an example: https://github.com/unepwcmc/tradehub-navigator/blob/develop/lib/tasks/import_tools.rake

## Publishing the gem
- Increase the version number in `version.rb`
- Update the change log `CHANGELOG.md`
- Commit your changes
- `cd wcmc_components`
- `gem build wcmc_components`
- Visit https://gem-server.unep-wcmc.org/ and upload 
