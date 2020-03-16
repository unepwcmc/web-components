require 'wcmc_components'

class Country < ApplicationRecord
  has_and_belongs_to_many :meas

  include WcmcComponents::Loadable
  include WcmcComponents::Filterable

  filter_on :name, type: 'single'
  filter_on :iso3
end
