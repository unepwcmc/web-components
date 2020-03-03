module WcmcComponents


  # pass a model class to this to create a filter table for that class
  class FilterTable

    def initialize klass
      @klass = klass
    end
    
    def import_csv_file file_name
      begin
        ActiveRecord::Base.transaction do
          CSV.foreach(file_name, headers: true, encoding:'iso-8859-1:utf-8') do |row|
            @klass.find_or_create_by!(row.to_h)
          end
        end
      rescue => e
        Rails.env.development? ? byebug : Appsignal.set_error(e)
      end
    end
    
  end
end
