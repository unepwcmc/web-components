module WcmcComponents
  module Filterable
    class Serializer
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

      private

      def serialize_item_for_table(item)
        {
          archived: item.archived?,
          pageUrl: item.table_page_path,
          editUrl: item.table_edit_path,
          archiveUrl: item.table_archive_path,
          cells: convert_item_to_table_row(item)
        }
      end

      def convert_item_to_table_row(item)
        item.attributes_for_table.map do |attribute_key, attribute_options|
          {
            name: attribute_key.to_s,
            title: attribute_options[:title],
            value: get_item_val(item, attribute_key, attribute_options),
            showInModal: attribute_options[:show_in_modal],
            showInTable: attribute_options[:show_in_table],
            legend_on: attribute_options[:legend_on]
          }
        end
      end

      def get_item_val(item, attribute_key, attribute_options)
        if attribute_options[:type] == 'multiple'
          table_name, attribute_name = attribute_key.to_s.split('.')

          item.send(table_name).map(&attribute_name.to_sym)
        else
          item.send(attribute_key)
        end
      end

      def total_pages(total_entries)
        return 0 if total_entries.zero?

        (total_entries.to_f / @table_parameters.items_per_page).ceil
      end
    end
  end
end
