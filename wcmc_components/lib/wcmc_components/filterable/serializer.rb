module WcmcComponents
  module Filterable
    class Serializer
      class << self
        # A class method that takes a Filterable object and converts it into a row for the FilterableTable
        def convert_item_to_table_row(item)
          item.attributes_for_table.map do |attribute_key, attribute_options|
            attribute_options.merge(
              {
                value: item.send(attribute_key)
              }
            )
          end
        end
      end

      delegate :current_page, :items_per_page, to: :@table_parameters

      def initialize(table_parameters)
        @table_parameters = table_parameters
      end

      # Takes an ActiveRecord relation as an argument (such as one returned by ::QueryObject) and returns a serialized 
      # hash ready to be sent to the FilterableTable component. It also uses information from @table_parameters.
      def serialize_relation_for_table(relation)
        {
          current_page: current_page,
          per_page: items_per_page,
          total_entries: relation.count,
          total_pages: total_pages(relation.count, @table_parameters.items_per_page),
          items: relation.map(&method(:serialize_item_for_table))
        }
      end

      def serialize_item_for_table(item)
        {
          page_url: item.table_page_path,
          edit_url: item.table_edit_path,
          cells: item.as_table_row
        }
      end

      private

      def total_pages(total_number_of_items, items_per_page)
        number_of_complete_pages, number_of_leftover_items = total_number_of_items.divmod(items_per_page)

        number_of_leftover_items.zero? ? number_of_complete_pages : number_of_complete_pages + 1
      end
    end
  end
end
