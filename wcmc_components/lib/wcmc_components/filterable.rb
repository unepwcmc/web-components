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
        base_path
      end

      # TODO: is there a better way to do this
      def table_edit_path
        "#{base_path}/#{id}/edit"
      end

      def table_archive_path
        "#{base_path}/#{id}/archive"
      end
    end

    def base_path
      @table_resource.class.name.downcase.pluralize
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
        @table_attributes.columns_as_json
      end
    end
  end
end
