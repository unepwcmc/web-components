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
      def filter_on(attr, options = {})
        (@filters ||= {})[attr] = options
      end

      # filter attributes are already included in columns displayed on table
      # this is 
      def table_column(attr, options = {})
        (@tab_cols ||= {})[attr] = options
      end

      # attributes shown in table modal
      def exclude_from_modal(attr, options = {})
        (@exclude_from_modal_items ||= {})[attr] = options
      end

      def filters
        @filters ||= {}
      end

      def tab_cols
        @tab_cols ||= {}
      end

      def exclude_from_modal_items
        @exclude_from_modal_items ||= {}
      end

      def filters_to_json
        full_list = self.all.order(id: :asc)
        filter_array = []
        filters.keys.each do |filter|
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
            id: item.id,
          }
          tab_cols.keys.each do |col|
            item_j[col.to_s]  = item[col] 
          end
          filters.keys.each do |col|
            item_j[col.to_s]  = item[col] 
          end
          item_j
        end.to_json
      end
      
      def all_to_csv
        json = self.all.order(id: :asc).to_a.map! do |item|
          item_j = {
            id: item.id,
          }
          tab_cols.keys.each do |col|
            item_j[col.to_s]  = item[col] 
          end
          filters.keys.each do |col|
            item_j[col.to_s]  = item[col] 
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

          tab_cols.each_key do |col|
            item_j[:cells] << {
              name: col.to_s,
              value: item[col],
              showInTable: true,
              showInModal: show_in_modal(col)
            }
          end

          filters.each_key do |col|
            item_j[:cells] << {
              name: col.to_s,
              value: item[col],
              showInTable: true,
              showInModal: show_in_modal(col)
            }
          end

          item_j
        end
      end

      def show_in_modal(col)
        !@exclude_from_modal_items.key?(col)
      end

      def show_page_path(item)
        return nil if WcmcComponents.classes_show_page_format.nil?

        format = WcmcComponents.classes_show_page_format[to_s]

        return nil if format.nil?

        format % item.id
      end

      def columns_to_json
        columns = []
        tab_cols.keys.each do |col|
          columns << {field: col,
                      title: tab_cols[col][:title] || col.to_s.gsub(/_/,' ').capitalize}
        end
        filters.keys.each do |col|
          columns << {field: col,
                      title: filters[col][:title] || col.to_s.capitalize}
        end
        columns.to_json
      end

      def paginate(json)
        json_params = json.nil? ? nil : JSON.parse(json)
        page = json_params.present? ? json_params['requested_page'].to_i : 1
        items_per_page = (json_params.present? && json_params['items_per_page'].present?) ? json_params['items_per_page'].to_i : 10

        filter_params = []

        if json_params.present? && json_params['filters'].present?
          filter_params = json_params['filters'].all? { |p| p['options'].blank? } ? [] : json_params['filters']
        end

        items = query_with_filters(filter_params)

        {
          current_page: page,
          per_page: items_per_page,
          total_entries: entries(items),
          total_pages: pages(items, items_per_page),
          items: filter_table(items.slice((page - 1) * items_per_page, items_per_page))
        }
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
