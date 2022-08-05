module WcmcComponents
  module Filterable
    class Serializer
      class << self
        # This method takes a relation as might be produced by a query from TableQueryObject, e.g. Country.all,
        # And transforms that relation into a hash in the form expected by the table

        # TODO: - it makes more sense to have the TableSerializer initialize with table parameters, and then run serialization on a relation.

        def serialize_relation_for_table(relation, table_parameters)
          {
            current_page: table_parameters.current_page,
            per_page: table_parameters.items_per_page,
            total_entries: relation.count,
            total_pages: total_pages(relation.count, table_parameters.items_per_page),
            items: relation.map(&method(:serialize_item_for_table))
          }
        end

        # Serialize item takes one instance of an ActiveRecord class as its argument
        # It returns an array of table cells in the form expected by the FilterableTable
        def serialize_item_for_table(item)
          item.table_attributes.attributes_for_table.map do |_attribute_key, _attribute_options|
            {
              page_url: item.table_page_path,
              cells: item.as_table_row
            }
          end
        end

        # Takes an item as its argument
        # Accesses that item's 'attributes for table' (which stores which properties of that item
        # are to be sent to the FilterableTable), and for each, will fetch the item's value for that attribute.
        def convert_item_to_table_row(item)
          item.attributes_for_table.map do |attribute_key, attribute_options|
            attribute_options.merge value: item.send(attribute_key)
          end
        end

        private

        def total_pages(total_number_of_items, items_per_page)
          number_of_complete_pages, number_of_leftover_items = total_number_of_items.divmod(items_per_page)

          number_of_leftover_items.zero? ? number_of_complete_pages : number_of_complete_pages + 1
        end
      end
    end
  end
end
