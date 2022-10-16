require 'wcmc_components/filterable/attributes'
require 'wcmc_components/filterable/parameters'
require 'wcmc_components/filterable/query_object'
require 'wcmc_components/filterable/serializer'

module WcmcComponents
  module Filterable
    extend ActiveSupport::Concern

    included do
      class_attribute :table_attributes, default: Attributes.new

      delegate :form_attributes, :table_columns, :attributes_for_table, to: :table_attributes
      # Gets the objects attributes and transforms them into one table row for the FilterableTable component
      def as_table_row
        Serializer.convert_item_to_table_row(self)
      end

      # table_page_path returns the 'show' path for the resource
      def table_page_path
        ''
      end
    end

    class_methods do
      delegate :attributes_for_table, :table_filters, :table_legends, :table_columns, to: :table_attributes

      # table_attribute is a wrapper for TableAttributes#add_attribute
      # Use this in the class definition to add an attribute
      def table_attribute(name, **options)
        table_attributes.add_attribute(name, options)
      end

      # The primary entrypoint method for serializing items of the base class for use in the FilterableTable component
      def paginate_for_table(**table_parameter_options)
        table_parameters = Parameters.new(table_parameter_options)
        query_results = QueryObject.new(self).query_with_table_parameters(table_parameters)
        Serializer.new(table_parameters).serialize_relation_for_table(query_results)
      end

      def columns_to_json
        table_attributes.table_columns
      end

      def paginate_api(json)
        json_params = json.nil? ? nil : JSON.parse(json)
        current_page = get_page(json_params)
        items_per_page = get_items_per_page(json_params)

        filter_params = get_filter_params(json_params)

        items = query_with_filters(filter_params)
        {
          current_page: current_page,
          per_page: items_per_page,
          total_entries: entries(items),
          total_pages: pages(items, items_per_page),
          items: filter_api(items.slice((current_page - 1) * items_per_page, items_per_page))
        }
      end
    end
  end
end
