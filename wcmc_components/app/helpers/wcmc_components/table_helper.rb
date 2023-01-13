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
  end
end
