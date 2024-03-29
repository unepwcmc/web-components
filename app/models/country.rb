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
                  show_in_csv: false,
                  type: 'single',
                  show_in_csv: true

  table_attribute :name,
                  title: 'Name',
                  filter_on: true,
                  type: 'single',
                  show_in_table: true,
                  legend_on: true,
                  form_builder_method: :text_field,
                  show_in_csv: true
  
  table_attribute :attr3,  
                  title: 'Attr3',
                  filter_on: true,
                  type: 'single',
                  show_in_table: true,
                  legend_on: true,
                  form_builder_method: :text_field,
                  show_in_csv: true
  
  table_attribute :attr4,
                  title: 'Attr4',
                  filter_on: true,
                  type: 'single',
                  show_in_table: true,
                  legend_on: true,
                  form_builder_method: :number_field,
                  show_in_csv: true


end
