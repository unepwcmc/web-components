module WcmcComponents
  module Filterable
    class CsvGenerator
      # Initialize with the active record class that you wish to query, e.g. Country
      def initialize(items)
        @items = items
      end

      def to_csv(csv_attributes)
        csv_string = CSV.generate(encoding: 'UTF-8') do |csv_line|
          # build headers for CSV from the column titles on the page
          headers = []
          csv_attributes.each do |_key, col|
            headers << col[:title]
          end
          csv_line << headers.flatten

          # build each row for CSV - matching 'value:' in the filter table
          @items.each do |item|
            row = []
            csv_attributes.each do |key, col|
              case col[:type]
              when 'single'
                row << item.send(key)
              when 'multiple'
                row << item.send(key.to_s.pluralize).map(&:name).join('; ')
              end
            end
            csv_line << row
          end
        end
      end
    end
  end
end
