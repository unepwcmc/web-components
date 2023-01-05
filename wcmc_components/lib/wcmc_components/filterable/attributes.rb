# frozen_string_literal: true

# TableAttributes is a service object class that can store information about an ActiveModel class's "table attributes"

module WcmcComponents
  module Filterable
    class Attributes
      attr_reader :attributes

      DEFAULT_ATTRIBUTES = {
        show_in_modal: true,
        show_in_table: false,
        show_in_csv: false
      }

      def initialize(attributes_hash = {})
        @attributes = attributes_hash

        add_attribute :id,
                      name: 'id',
                      title: 'Id',
                      type: 'single'
      end

      # add_attribute is the main method provided to store
      def add_attribute(name, **options)
        @attributes[name] = DEFAULT_ATTRIBUTES.merge(options)
      end

      def attributes_for_table
        attributes
      end

      def table_filters(table_resources)
        filterable_attributes.map do |key, value|
          get_table_attribute(table_resources, key, value)
        end
      end

      def table_legends(table_resources)
        legend_attributes.map do |key, value|
          get_table_attribute(table_resources, key, value)
        end
      end

      # def table_columns_and_modal_items
      #   get_attributes_with_options(:show_in_table, :show_in_modal)
      # end

      def table_columns
        table_attributes.map do |column_name, column_options|
          {
            field: column_name,
            title: column_options[:title] || column_name.to_s.gsub(/_/, ' ').capitalize,
            sortable: column_options[:sortable]
          }
        end.to_json
      end

      # Return a subset of all attributes; only those which belong to *other* tables
      # E.g. if a country has_one CapitalCity, a listed attribute in the country class could be 'capital_citys.name'
      # Note: This method assumes any attribute containing a '.' to be on an associated table
      def association_attributes
        attributes.select do |key, _value|
          key.to_s.include? '.'
        end
      end

      # A partner to the above method, but returns the names of the tables that the association_attributes belong to.
      # E.g., if a country has attributes 'capital_citys.name', 'capital_citys.population', 'continents.name',
      # this will return ['capital_citys', 'continents'], allowing a #join to be run before querying those attributes
      def association_tables
        associated_attribute_names = association_attributes.keys

        associated_attribute_names.map do |name|
          name.to_s.split('.').first.to_sym
        end.uniq
      end

      def csv_attributes
        get_attributes_with_options(:show_in_csv)
      end

      # Returns the attributes for which the `form` option is truthy.
      def form_attributes
        get_attributes_with_options(:form_builder_method)
      end

      private

      def get_table_attribute(table_resources, key, value)
        {
          name: key.to_s,
          title: value[:title] || key.to_s.capitalize,
          options: get_table_attribute_options(table_resources, key, value),
          type: value[:type]
        }
      end

      def get_table_attribute_options(table_resources, filter_key, filter)
        case filter[:type]
        when 'single'
          table_resources.order(id: :asc)
            .pluck(filter_key)
            .compact
            .uniq
            .sort
        when 'multiple'
          options_array = table_resources.preload(filter_key)
            .collect(&filter_key)
            .flatten
            .uniq
            .map(&:name) || []
          
          options_array.sort
        end
      end

      # A method that will return a subset of @attributes
      # Only those which have one of options_symbols as a (truthy) key will be returned
      # This method is used by public methods above, e.g. filters, table_columns, etc.
      def get_attributes_with_options(*option_symbols)
        @attributes.select do |_key, value|
          option_symbols.any? { |option_symbol| value[option_symbol] }
        end
      end

      def filterable_attributes
        get_attributes_with_options(:filter_on)
      end

      def legend_attributes
        get_attributes_with_options(:legend_on)
      end

      def table_attributes
        get_attributes_with_options(:show_in_table)
      end
    end
  end
end
