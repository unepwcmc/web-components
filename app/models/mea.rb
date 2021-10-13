require 'wcmc_components'

class Mea < ApplicationRecord
  include WcmcComponents::Loadable
  include WcmcComponents::Filterable

  has_and_belongs_to_many :countries
  import_by countries: :name

  table_attr :countries,
             title: 'Country',
             filter_on: true,
             show_in_table: true,
             type: 'multiple'
    
  
end
