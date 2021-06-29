require 'wcmc_components'

class Mea < ApplicationRecord
  has_and_belongs_to_many :countries
  include WcmcComponents::Loadable
  include WcmcComponents::Filterable
  import_by countries: :name
end
