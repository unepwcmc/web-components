require 'wcmc_components'
class Project < ApplicationRecord
  include WcmcComponents::Loadable

  belongs_to :country

  # what property should we import this relation from in the csv loader
  # will default to the association_primary_key, which is usally 'id'
  # in this case, our csv will have a column called 'country' containing a string 'United Kingdon'
  # which is the country.name. Using this we could also import e.g. csvs with countries described by ISO3 etc.
  import_by country: :name

  # We often receive CSVs with columns that, while meaningful to the spreadsheet creator, don't need to
  # be imported - you can list these here
  ignore_column :spurious
  ignore_column :irrelevant
end
