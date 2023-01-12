# wcmc_components - version 1.0.0

Features:
- Import csv files as database records
- Add filterable, editable tables for the UI, with modals and csv export

## Getting up and running
* bundle
* yarn install

Terminal 1:
* rails s

Terminal 2:
* webpack-dev-server

## Running Tests
Terminal 3:
* yarn test

This will run all tests in `**.spec.js` files contained within the `components` file.
The tests run using Jest and will re-run within the terminal on saved changes. Console logs are printed into the terminal.

If you are using imports from node_modules, make sure to add the modules (as exceptions) to transformIgnorePatterns in package.json, to make sure these are transpiled.

Also, if verbose is set to true for yarn test, often console logs are overwritten in the terminal when using --watchAll. Another solution to the missing logs is to do a single test run (remove --watchAll)

## How to Use the WcmcComponents Table Engine

### About the `WcmcComponents` gem

The WcmcComponents module has three sub-modules:

- **WcmcComponents::Filterable** can be included in an ActiveRecord class to provide it with methods to edit the database, query the database and apply filters, sorting and serialization. Its main entrypoint is the `#paginate` method, which serves filtered, sorted data from that ActiveRecord class in the format expected by the FilterableTable component.
- **WcmcComponents::Loadable** provides the ability to import data into a DB table from a CSV. 
- **WcmcComponents::Engine** is a [Rails engine](https://guides.rubyonrails.org/engines.html) which can be mounted in a host application to automatically provide two new routes and controller actions, which can be seen in `wcmc_components/config/routes.rb`. Each mounted Engine provides a table route and a download route; the Engine can be mounted as many times as you like, but each requires registration in `config/initializers/wcmc_components.rb` as detailed below.

### Add gem(s) to spec

in Gemfile add either:

* gem 'wcmc_components', '~> 1.0.0', source: "https://gem-server.unep-wcmc.org/"

or to use local code cloned into web-components

* gem 'wcmc_components', path: '../web-components/wcmc_components'

Add ```//= link wcmc_components_manifest.js``` to ```assets/config/manifest.js```

For upgrades notes see ```Upgrading notes``` section

**For filterable table functionality you will also need to import a [compatible version](https://github.com/unepwcmc/wiki/wiki/Reusable-Component-Version-Compatibility) of the [wcmc-components vue library](https://github.com/unepwcmc/wcmc-components)**

### Add archived to your model
To support archiving, you will need to run a migration to add an attribute called `archived` with type Boolean to your model. This is required to prevent the app erroring.

```add_column :headline_indicators, :archived, :boolean, default: 0```

### Decorate your model
In the model you want to display in a filter table add 

* include WcmcComponents::Filterable

and optionally configure columns using the table_column method, e.g.
*   table_attribute :created_at, title: 'First Date'

```
# Add this method for each of the fileds you want to display in the table
table_attribute(
  :bip_indicator,                    # the model attribute, either a database field or method on the model
  title: 'BIP Indicator',            # the title that will appear in the tables, modals, and csv files
  filter_on: true,                   # if true, attribute will be filterable in UI table. Will only filter database fields
  type: 'single',                    # if 'single', this is a field on this class, if 'multiple' the model attribute needs to be defined as `:'model_table.attribute'`.
  show_in_table: false,              # show or hide the field in the UI table
  show_in_modal: true,               # show or hide the field in the modal
  show_in_csv: true,                 # show or hide the table in the csv export. Default is false.
  sortable: true,                   # if false, the api and table endpoints will allow sorting by this attribute. Default is false
  form_builder_method: :text_field,  # The rails helper method used to render the form field when creating or editing a model record
  required: true                     # Applied to the form fields, defaults to false
)

```

see app/models/country.rb as an example

If you want to allow editing associated records via the form you need to add a call to ```add_form_methods_for_associated_records``` in your table classes below the table_attribute method calls.
TODO: Find a way to do this automatically

Currently, the 'show' button redirects to a show page by default. To make the button open a modal instead you need to override the
`#table_page_path` method in your model classes: 
```
def table_page_path
  nil
end
```

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

### Add a controller and page for the component

An example index with props for an Example class:
```
# controllers/examples_controller.rb

class ExamplesController < ApplicationController
  def index
    @filterable_table_props = {
      attributes: Example.columns_to_json,
      endpoint: examples_table_path,
      endpoint_download: '/examples/download',
      filter_array: Example.table_filters_with_options.to_json,
      legend_array: Example.table_legends_with_options.to_json,
      options: {}
    }
  end
end
```

The options argument takes an object that with styling configuration ([see the front-end component wiki](https://github.com/unepwcmc/wcmc-components/wiki)).

Then initialise the Vue component in the view:
```
# views/examples/index.html.erb

<filterable-table
  class="p-10 md:px-20"
  :attributes="<%= @filterable_table_props[:attributes] %>"
  endpoint="<%= @filterable_table_props[:endpoint] %>"
  endpoint-download="<%= @filterable_table_props[:endpoint_download] %>"
  :filter-array="<%= @filterable_table_props[:filter_array] %>"
  :legend-array="<%= @filterable_table_props[:legend_array] %>"
  :options="<%= @filterable_table_props[:options] %>"
  :items-per-page="15"
>
```

## How to Use the WcmcComponents CSV Importer

Note: When importing an association, if a record is not found based on the csv string being parsed, the importer attempts to create the record. If the record being created has several required fields this will fail, so the associated record would need to be created before the import.

### Setting up your class for import

```
require 'wcmc_components'
class Project < ApplicationRecord
  include WcmcComponents::Loadable
  
  belongs_to :country
  
  # what property should we import this relation from in the csv loader
  # will default to the association_primary_key, which is usally 'id'
  # in this case, our csv will have a column called 'country' containing a string 'United Kingdon'
  # which is the country.name. Using this we could also import e.g. csvs with countries described by ISO3 etc.
  import_by country: :name

  # will import has_many and has_and_belongs_to_many from csv cell split with ;
  # e.g. www.foo.com;www.bar.net
  has_many :websites, dependent: :destroy
  import_by websites: :url

  has_and_belongs_to_many :managers, dependent: :destroy
  import_by manager: :email

  # We often receive CSVs with columns that, while meaningful to the spreadsheet creator, don't need to
  # be imported - you can list these here
  ignore_column :spurious
  ignore_column :irrelevant
end
```

### Importing the CSV data

CSV files must be located in the lib/data/seeds directory, or the test/seeds directory for testing.

Start the import with, e.g. ```Project.import```

With no arguments the importer will attempt to find a CSV with the snakecase version of the class name.

You can specify a different file name, and specify the encoding of the CSV:
```Project.import('special_projects', 'iso-8859-1:utf-8')```


### Create migrations
TODO - improve these docs and provide examples in this repo
- Create a migration for your CSV
- Create a join table migration for fields with multiple values

Migrations must include a boolean `archived` attribute.

### Create rake tasks
TODO - improve these docs and provide examples in this repo
You will need to create a rake task that imports the CSV.
See tradehub-navigator repo for an example: https://github.com/unepwcmc/tradehub-navigator/blob/develop/lib/tasks/import_tools.rake

```
require 'csv'

namespace :import do
  desc "Import CSV data into database"
  task :tools, [:csv_file] => [:environment] do |t, args|
    import_csv_file(args.csv_file)
    puts "CSV successfully imported"
  end

  def import_csv_file file
    Tool.import file, 'utf-8'
  end
end
```

## Publishing the gem
- Increase the version number in `version.rb`
- Update the change log `CHANGELOG.md`
- Commit your changes
- `cd wcmc_components`
- `gem build wcmc_components`
- Visit https://gem-server.unep-wcmc.org/ and upload 

## Querying the database
The api, table and download endpoints all allow the following query parameters:

```
:requested_page,
:items_per_page,
filters: [:name, :type, options: []],
sort: %i[column ascending]
```

Note, for download the pagination parameters will be ignored.

## API
TODO: Add documentation.

The API enables host applications to quickly and easily expose an endpoint which can then be queried to produce serialized JSON data for one of the host application’s models

## Editable
TODO: Add documentation.

Editable functionality is currently only available to users with the wcmc role. To add editing buttons to the table you need specify in the options object, e.g. 
```
if current_user&.role == 'wcmc'
  options.merge({ showArchived: true, showEdit: true })
else
  options
end
```

# Upgrade notes

## 0.4.0 to 1.0.0

- create a migration to add a boolean ```archived``` attribute to your table models
- replace ```#table_attr``` with ```#table_attributes```
- replace model attribute where table attribute is multiple with ```:'table_name.attriibute'``` e.g.
```
table_attribute :'institution',
  type: 'multiple'

# becomes: 
table_attribute :'institutions.name',
  type: 'multiple'
```
- add ```show_in_csv: true``` in table_attribute method for fields that should be included in csv export file
- override ```#table_page_path``` in your models if you want the show page to be shown in a modal rather than a page: 
```
  def table_page_path; nil; end
```
- in controllers replace ```#attributes_to_json('filters')``` with ```#table_filters_with_options.to_json``` and ```#attributes_to_json('legends')``` with ```#table_legends_with_options.to_json```
