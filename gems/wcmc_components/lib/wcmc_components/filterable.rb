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
      def filter_on attr, options = {}
        (@filters ||= {} )[attr] = options
      end

      # filter attributes are already included in columns displayed on table
      # this is 
      def table_column attr, options = {}
        (@tab_cols ||= {} )[attr] = options
      end
      
      def filters
        @filters ||= {}
      end

      def tab_cols
        @tab_cols ||= {}
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

      
    end
  end
end
