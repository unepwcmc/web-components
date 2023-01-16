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

    def form_field_values (key, attributes)
      if (attributes[:type] == 'multiple')
        table_name, table_attribute = key.to_s.split('.')
        ["#{attributes[:title]} - #{table_attribute} (; seperated values)", @table_resource.send(table_name]
      else
        [attributes[:title], @table_resource[key]]
      end
    end
  end
end
