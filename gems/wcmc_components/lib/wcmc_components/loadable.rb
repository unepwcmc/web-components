require 'csv'
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
        begin
          ActiveRecord::Base.transaction do
            
            CSV.foreach(seed, headers: true, encoding:'iso-8859-1:utf-8') do |row|
              row_hash = row.to_h
              # look up object for each belongs_to column - assumes column name is class name
              belongs_to = self.reflections.select{|key,hash| hash.macro == :belongs_to}
              belongs_to.each do | k, v|
                owner = k.capitalize.constantize.find_by(name: row_hash[k])
                row_hash[k] = owner
              end
              
              
              self.find_or_create_by!(row_hash)
              
            end
          end
        rescue => e
          Rails.env.test? ? byebug : Rails.logger.error(e)
        end
      end

      def csv_file_path base_file_name=nil
        base_file_name ||="#{self.to_s.pluralize.downcase}.csv"
        seed = Rails.env.test? ?
                 Rails.root.join('test','seeds',base_file_name) :
                 Rails.root.join('lib','data','seeds',base_file_name)
      end
    end

  end
end
