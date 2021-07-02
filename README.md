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


### Add gem(s) to spec

in Gemfile add either:

* gem 'wcmc-components', '~> 0.1.0', source: "https://gem-server.unep-wcmc.org/"

or to use local code cloned into web-components

* gem 'wcmc-components', path: '../web-components/wcmc_components'

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

* WcmcComponents.routes_classes = {'/countries/' => 'Country'}

TODO: I think I should be able to figure these mappings automagically from the mount line but can't make this work (yet!)

