# frozen_string_literal: true

# TableParameters is a service object class to handle the parameters received in the TableController
# It is also concerned with translating its parameters into SQL (but does not handle executing queries)

module WcmcComponents
  module Filterable
    class Parameters
      attr_reader :current_page, :items_per_page, :filters, :sort

      def initialize(**options)
        @active_record_class = options[:active_record_class]
        @current_page = to_positive_integer(options[:requested_page], 1)
        @items_per_page = to_positive_integer(options[:items_per_page], 10)
        @filters = options[:filters] || []
        @sort = options[:sort] || {}
        @is_admin = options[:is_admin]
      end

      # Turns the active filters into a string of valid SQL to pass to ActiveRecord::QueryMethods#where
      def filters_as_sql
        conditions_array = active_filters.map do |filter|
          name_string = attribute_with_table_name(filter[:name])
          options_string = convert_options_array_to_sql_syntax(filter[:options])

          "#{name_string} IN #{options_string}"
        end

        conditions_array.push('(archived = false OR archived IS NULL)') unless @is_admin

        conditions_array.join(' AND ')
      end

      # Turns the page params into a string of valid SQL to pass to ActiveRecord::QueryMethods#where
      def sql_offset
        (@current_page - 1) * @items_per_page
      end

      def sql_limit
        @items_per_page
      end

      # Translates @sort into valid SQL which can by passed to ActiveRecord::QueryMethods#order
      def sort_as_sql
        if @sort[:column]
          sort_col_config = attribute_config(@sort[:column])
          return 'id ASC' if (sort_col_config[:type] == 'multiple') || (sort_col_config.key?(:sortable) && !sort_col_config[:sortable])
        end
        # sort by id per default
        column = attribute_with_table_name(@sort[:column] || 'id')
        # Sort ascending per default (when no direction is specified)
        direction = @sort[:ascending] == false ? 'DESC' : 'ASC'

        "#{column} #{direction}"
      end

      private

      def attribute_config(attribute_id)
        @active_record_class.table_attributes.attributes[attribute_id.to_sym]
      end

      def attribute_with_table_name(attribute_name)
        unless attribute_name.include?('.')
          "#{@active_record_class.table_name}.#{attribute_name}"
        else
          attribute_name
        end
      end

      def to_positive_integer(value, default = 1)
        int = value.to_i

        int <= 0 ? default : int
      end

      # Takes an array of strings and returns them in SQL array syntax
      # E.g. Array:['cat', 'dog', 'mouse'] => String:"('cat','dog','mouse')"
      def convert_options_array_to_sql_syntax(options_array)
        apostrophised_options = options_array.map { |option_string| "'#{option_string}'" }

        "(#{apostrophised_options.join(',')})"
      end

      def active_filters
        @filters.select { |filter| filter[:options].present? }
      end
    end
  end
end
