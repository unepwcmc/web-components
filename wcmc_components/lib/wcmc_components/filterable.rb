module WcmcComponents
  module Filterable
    def self.included base
      base.send :include, InstanceMethods
      base.extend ClassMethods
    end

    module InstanceMethods
    end

    module ClassMethods
      # declare attrs you want to filter on
      def table_attr(attr, options = {})
        (@table_attrs ||= {})[attr] = options
      end

      def filters
        table_attrs.select { |_k, v| v[:filter_on] } || {}
      end

      def table_cols
        table_attrs.select { |_k, v| v[:show_in_table] } || {}
      end

      def table_cols_and_modal_items
        table_attrs.select { |_k, v| v[:show_in_table] || v[:show_in_modal] } || {}
      end

      def table_attrs
        @table_attrs ||= {}
      end

      def filters_to_json
        full_list = self.all.order(id: :asc)
        filter_array = []
        filters.each_key do |filter|
          filter_array << {
            name: filter.to_s,
            title: filters[filter][:title] || filter.to_s.capitalize,
            options: full_list.pluck(filter).compact.uniq.sort,
            type: filters[filter][:type] || 'multiple'
          }
        end
        filter_array.to_json
      end

      def all_to_json
        json = self.all.order(id: :asc).to_a.map! do |item|
          item_j = {
            id: item.id
          }

          table_attrs.each_key do |col|
            item_j[col.to_s] = item[col]
          end

          item_j
        end.to_json
      end

      def all_to_csv
        json = self.all.order(id: :asc).to_a.map! do |item|
          item_j = {
            id: item.id
          }

          table_attrs.each_key do |col|
            item_j[col.to_s] = item[col]
          end

          item_j
        end.to_json
      end

      def filter_table(items)
        items.map! do |item|
          item_j = {
            pageUrl: show_page_path(item),
            cells: []
          }

          item_j[:cells] << {
            name: 'id',
            value: item.id,
            showInTable: false,
            showInModal: false
          }

          table_cols_and_modal_items.each do |key, col|
            item_j[:cells] << {
              name: key.to_s,
              value: item[key],
              showInTable: col[:show_in_table],
              showInModal: col[:show_in_modal]
            }
          end

          item_j
        end
      end

      def show_page_path(item)
        return nil if WcmcComponents.classes_show_page_format.nil?

        format = WcmcComponents.classes_show_page_format[to_s]

        return nil if format.nil?

        format % item.id
      end

      def columns_to_json
        columns = []
        table_cols.keys.each do |col|
          columns << {field: col,
                      title: table_cols[col][:title] || col.to_s.gsub(/_/,' ').capitalize}
        end
        columns.to_json
      end

      def paginate(json)
        json_params = json.nil? ? nil : JSON.parse(json)
        current_page = get_page(json_params)
        items_per_page = get_items_per_page(json_params)

        filter_params = []

        if json_params.present? && json_params['filters'].present?
          filter_params = json_params['filters'].all? { |p| p['options'].blank? } ? [] : json_params['filters']
        end

        items = query_with_filters(filter_params)

        {
          current_page: current_page,
          per_page: items_per_page,
          total_entries: entries(items),
          total_pages: pages(items, items_per_page),
          items: filter_table(items.slice((current_page - 1) * items_per_page, items_per_page))
        }
      end

      def get_page(json_params)
        if json_params.present? && json_params['requested_page'].present?
          json_params['requested_page'].to_i
        else
          1
        end
      end

      def get_items_per_page(json_params)
        if json_params.present? && json_params['items_per_page'].present?
          json_params['items_per_page'].to_i
        else
          10
        end
      end

      def entries(items)
        items.count
      end

      def pages(items, items_per_page)
        return 0 if items.count == 0

        items.each_slice(items_per_page).count
      end

      def sql_from_filters(filters)
        params = {}
        filters.each do |filter|
          # single quote the options (if strings!?)
          options = filter['options'].map{ |v| "'#{v}'" }
          name = filter['name']
          params[name] = "#{self.table_name}.#{name} IN (#{options.join(',')})"

        end
        params.compact
      end

      def query_with_filters (filters)
        where_params = sql_from_filters(filters)

        where(where_params.values.join(' AND ')).order('id ASC').to_a
      end
    end
  end
end
