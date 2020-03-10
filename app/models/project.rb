require 'wcmc_components'
class Project < ApplicationRecord
  belongs_to :country

  include WcmcComponents::Loadable
end
