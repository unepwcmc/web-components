require 'wcmc_components/filterable/table_attributes'
require 'wcmc_components/filterable/table_parameters'
require 'wcmc_components/filterable/table_query_object'

module WcmcComponents
  module Filterable
    def self.included(base)
      base.extend ClassMethods

      # The following block is run in the context of the class where Filterable is included
      # The instance variables set here belong to that base class.
      base.instance_eval do
        # @table_attributes stores information about which columns in the DB are to be included in the FilterableTable
        @table_attributes = TableAttributes.new

        # @table_query_object builds and executes DB queries on behalf of the Filterable module
        @table_query_object = TableQueryObject.new(base)
      end
    end

    module ClassMethods
      attr_accessor :table_attributes, :table_query_object

      # table_attribute is a wrapper for TableAttributes#add_attribute
      # Use this in the class definition to add an attribute
      def table_attribute(name, **options)
        @table_attributes.add_attribute(name, options)
      end

      # The primary entrypoint method for serializing items of the base class for use in the FilterableTable component
      def paginate_for_table(**table_parameter_options)
        table_parameters = TableParameters.new(**table_parameter_options)
        query_results = @table_query_object.query_with_table_parameters(table_parameters)
        total_number_of_items = query_results.length

        {
          current_page: table_parameters.current_page,
          per_page: table_parameters.items_per_page,
          total_entries: total_number_of_items,
          total_pages: table_parameters.get_number_of_pages(total_number_of_items),
          items: query_results
        }
      end

      def columns_to_json
        @table_attributes.columns_as_json
      end
    end
  end
end
