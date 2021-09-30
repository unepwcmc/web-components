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
        filters_arr = []
        full_list.map do |item| 
        # filter = []  
        # when single filter just build array here
          filters_arr << {
            name: 'id',
            title: 'Id',
            options: item.id,
            # we only need columns with filters on to return?
            filter_on: false,
            type: '',
            # showInModal: false
          }
          # then if it's multiple do the second loop with id matching and pass the options (probably need to do something with them)
          
          table_cols_and_modal_items.each do |key, col|
            case col[:type]
            when "single"
              filters_arr << { 
              name: key.to_s,
              title: col[:title] || col.to_s.capitalize,
              options: item[key],
              filter_on: col[:filter_on],
              type: col[:type]
              }
            when "multiple"
              # byebug
              filters_arr << {
                name: key.to_s,
                title: col[:title] || col.to_s.capitalize,
                options: item.send(key.to_s.pluralize).map(&:name),
                filter_on: col[:filter_on],
                type: col[:type]
              }
            end
          end
          # filter.to_json
        end
        filters_arr.to_json
      end
      
        
    #       filter_array = []
    #       byebug
    #       item_j = {
    #         pageUrl: show_page_path(item),
    #         filters: filter_array
    #       }

    #       item_j[:filters] << {
    #         name: 'id',
    #         title: 'Id',
    #         options: item.id,
    #         type: ''
    #       }
    #     table_cols_and_modal_items.each do |key, filter|
    #       case filter[:type]
    #       when "single"
    #         item_j[:filters] << {
    #           name: key.to_s,
    #           title: filter[:title] || filter.to_s.capitalize,
    #           options: item.pluck(key).compact.uniq.sort,
    #           type: filter[:type] || 'multiple'
    #         }
    #       when "multiple"
    #         # byebug
    #         item_j[:filters] << {
    #           name: key.to_s,
    #           title: filter[:title] || filter.to_s.capitalize,
    #           options: item.send(key.to_s.pluralize).map(&:name),
    #           type: filter[:type] || 'multiple'
    #         }
    #       end
    #     end
    #     filter_array.to_json
    #   end
    # end

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

      def to_csv(json)
        json_params = json.nil? ? nil : JSON.parse(json)
        filter_params = get_filter_params(json_params)

        items = query_with_filters(filter_params)

        csv_string = CSV.generate(encoding: 'UTF-8') do |csv_line|
          
          # build headers for CSV from the column titles on the page
          headers = ['Id']
          table_cols_and_modal_items.each do |key,col|
            headers << col[:title]
          end
          csv_line << headers.flatten

          # build each row for CSV - matching 'value:' in the filter table
          items.each do |item|
            row = []
            row << item.id
            table_cols_and_modal_items.each do |key,col|
              case col[:type]
              when "single"
                row << item[key]
              when "multiple"
                row << item.send(key.to_s.pluralize).map(&:name).join('; ')
              end
            end
            csv_line << row
          end
        end
      end
      
      def filter_table(items)
        items.map! do |item|
          byebug
          item_j = {
            pageUrl: show_page_path(item),
            cells: []
          }

          item_j[:cells] << {
            name: 'id',
            title: 'Id',
            value: item.id,
            showInTable: false,
            showInModal: false
          }
          # title and values also used in to_csv() to generate a CSV so if making changes here, also look there!
          table_cols_and_modal_items.each do |key, col|
            case col[:type]
            when "single"
              item_j[:cells] << {
                name: key.to_s,
                title: col[:title],
                value: item[key],
                showInTable: col[:show_in_table],
                showInModal: col[:show_in_modal]
              }
            when "multiple"
              # byebug
              item_j[:cells] << {
                name: key.to_s,
                title: col[:title],
                value: item.send(key.to_s.pluralize).map(&:name),
                showInTable: col[:show_in_table],
                showInModal: col[:show_in_modal]
              }
            end
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
        
        filter_params = get_filter_params(json_params)

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

      def get_filter_params(json_params)
        if json_params.present? && json_params['filters'].present?
          filter_params = json_params['filters'].all? { |p| p['options'].blank? } ? [] : json_params['filters']
        else
          []
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
          next if filter['options'].count == 0
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
