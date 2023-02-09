module WcmcComponents
  module TableHelper
    def form_path (type)
      case type
      when 'edit'
        table_path
      when 'new'
        create_table_path
      end
    end

    def label_and_attribute(key, attributes)
      if attributes[:type] == 'multiple'
        table_name, table_attribute = key.to_s.split('.')
        [
          "#{attributes[:title]} - #{table_attribute} (; seperated values)",
          "#{table_name}_#{table_attribute.pluralize}".to_sym
        ]
      else
        [attributes[:title], key]
      end
    end
  end
end
