require 'wcmc_components'

class Country < ApplicationRecord
  has_and_belongs_to_many :meas

  include WcmcComponents::Loadable
  include WcmcComponents::Filterable

  table_attr :name, title: 'Name', filter_on: true, type: 'single', show_in_table: true
  table_attr :iso3, title: 'ISO 3 Code', show_in_table: true
end
