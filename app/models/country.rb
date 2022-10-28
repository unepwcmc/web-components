require 'wcmc_components'

class Country < ApplicationRecord
  has_and_belongs_to_many :meas

  include WcmcComponents::Loadable
  include WcmcComponents::Filterable

  table_attribute :iso3,
                  title: 'ISO 3 Code',
                  filter_on: true,
                  show_in_table: true,
                  show_in_modal: true,
                  type: 'single'

  table_attribute :name,
                  title: 'Name',
                  filter_on: true,
                  type: 'single',
                  show_in_table: true,
                  legend_on: false,
                  form: :text
end
