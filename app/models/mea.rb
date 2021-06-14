require 'wcmc_components'

class Mea < ApplicationRecord
  include WcmcComponents::Loadable

  has_and_belongs_to_many :countries
  import_by countries: :name
    
end
