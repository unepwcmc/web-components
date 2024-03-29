require 'wcmc_components'

class Mea < ApplicationRecord
  include WcmcComponents::Loadable
  include WcmcComponents::Filterable

  has_and_belongs_to_many :countries
  import_by countries: :name

  table_attribute :'countries.name',
                  title: 'Country',
                  filter_on: true,
                  show_in_table: true,
                  type: 'multiple',
                  sortable: false,
                  show_in_csv: true
end
