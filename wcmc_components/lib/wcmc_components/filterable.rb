require 'wcmc_components/filterable/attributes'
require 'wcmc_components/filterable/parameters'
require 'wcmc_components/filterable/query_object'
require 'wcmc_components/filterable/serializer'

module WcmcComponents
  module Filterable
    def self.included(base)
      base.extend ClassMethods
      base.include InstanceMethods

      # The following block is run in the context of the class where Filterable is included
      # The instance variables set here belong to that base class.
      base.instance_eval do
        # @table_attributes stores information about which columns in the DB are to be included in the FilterableTable
        class_attribute :table_attributes, default: TableAttributes.new
      end
    end

    module InstanceMethods
      delegate :attributes_for_table, to: :table_attributes
      # Gets the objects attributes and transforms them into one table row for the FilterableTable component
      def as_table_row
        TableSerializer.convert_item_to_table_row(self)
      end

      # table_page_path returns the 'show' path for the resource
      def table_page_path
        ''
      end
    end

    module ClassMethods
      # table_attribute is a wrapper for TableAttributes#add_attribute
      # Use this in the class definition to add an attribute
      def table_attribute(name, **options)
        table_attributes.add_attribute(name, options)
      end

      # The primary entrypoint method for serializing items of the base class for use in the FilterableTable component
      def paginate_for_table(**table_parameter_options)
        table_parameters = TableParameters.new(table_parameter_options)
        query_results = TableQueryObject.new(self).query_with_table_parameters(table_parameters)
        TableSerializer.serialize_relation_for_table(query_results, table_parameters)
      end

      def columns_to_json
        @table_attributes.columns_as_json
      end
    end
  end
end
