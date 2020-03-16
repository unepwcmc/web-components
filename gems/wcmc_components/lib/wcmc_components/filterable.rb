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

      def filters
        @filters
      end
      
      def filters_to_json
        full_list = self.all.order(id: :asc)
        filter_array = []
        @filters.keys.each do |filter|
          filter_array << {
            name: filter.to_s,
            title: @filters[filter][:title] || filter.to_s.capitalize,
            options: full_list.pluck(filter).compact.uniq.sort,
            type: @filters[filter][:type] || 'multiple'
            
          }
        end
        filter_array.to_json
      end
    end
    
  end
end
