module WcmcComponents
  module Loadable
    
    def self.included base
      base.send :include, InstanceMethods
      base.extend ClassMethods
    end

    module InstanceMethods
    end

    module ClassMethods
      def import file_name=nil
        seed = csv_file_path file_name
      end

      def csv_file_path base_file_name=nil
        base_file_name ||="#{self.to_s.pluralize.downcase}.csv"
        seed = Rails.env.test? ?
                 Rails.root.join('test','seeds',base_file_name) :
                 Rails.root.join('lib','data','seeds',base_file_name)
      end
    end
    
#    def Loadable.import file_name
 ##     begin
   #     puts file_name
#        ActiveRecord::Base.transaction do
          
#          CSV.foreach(file_name, headers: true, encoding:'iso-8859-1:utf-8') do |row|
 #           self.class.find_or_create_by!(row.to_h)
  #        end
 #       end
    #  rescue => e
        #        Rails.env.development? ? byebug : Appsignal.set_error(e)
     #   byebug
     # end
  end
end
