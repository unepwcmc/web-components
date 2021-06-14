require 'wcmc_components'

class Country < ApplicationRecord
  has_and_belongs_to_many :meas

  include WcmcComponents::Loadable
  include WcmcComponents::Filterable

  filter_on :name, type: 'single'
  filter_on :iso3, title: 'ISO 3 Code'

  table_column :created_at, title: 'First Date'
  table_column :updated_at
end
