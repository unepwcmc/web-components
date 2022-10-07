module WcmcComponents
  module TableHelper
    def form_url (type)
      case type
      when 'edit'
        "/#{form_base_url}/#{@table_resource.id}"
      else
        "/#{form_base_url}"
      end
    end

    def form_base_url
      @table_resource.class.name.downcase.pluralize
    end
  end
end
