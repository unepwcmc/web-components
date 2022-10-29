module WcmcComponents
  module Filterable
    class Serializer
      class << self
        # A class method that takes a Filterable object and converts it into a row for the FilterableTable
        def convert_item_to_table_row(item)
          item.attributes_for_table.map do |attribute_key, attribute_options|
            # TODO: add CSV?
            {
              name: attribute_options[:name],
              title: attribute_options[:title],
              value: item.send(attribute_key),
              showInModal: attribute_options[:show_in_modal],
              showInTable: attribute_options[:show_in_table],
              legend_on: attribute_options[:legend_on]
            }
          end
        end
      end

      delegate :current_page, :items_per_page, to: :@table_parameters

      def initialize(table_parameters)
        @table_parameters = table_parameters
      end

      # Takes an ActiveRecord relation as an argument (such as one returned by ::QueryObject) and returns a serialized 
      # hash ready to be sent to the FilterableTable component. It also uses information from @table_parameters.
      def serialize_relation_for_table(query)
        {
          current_page: current_page,
          per_page: items_per_page,
          total_entries: query[:total],
          total_pages: total_pages(query[:total]),
          items: query[:results].map(&method(:serialize_item_for_table))
        }
      end

      def serialize_relation_for_api(query)
        {
          current_page: current_page,
          per_page: items_per_page,
          total_entries: query[:total],
          total_pages: total_pages(query[:total]),
          items: query[:results]
        }
      end

      def serialize_item_for_table(item)
        {
          pageUrl: item.table_page_path,
          cells: item.as_table_row
        }
      end

      private

      def total_pages(total_entries)
        return 0 if total_entries.zero?

        (total_entries.to_f / @table_parameters.items_per_page).ceil
      end
    end
  end
end
