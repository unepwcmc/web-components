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
              # look up objects for each HABTM column - assumes column name is pluralised class name
              habtm = self.reflections.select{|key,hash| hash.macro == :has_and_belongs_to_many}

              # habtm columns need adding later, so exclude them in the 
              new_object = self.find_or_create_by!(row_hash.except(*habtm.keys))

              # now look up the habtm's which should be semi-colon separated values
              habtm.each do | k, v|
                # check if the habtm relationship is in this csv
                if (row.headers.include?(k))
                  list_of_children = row_hash[k].split(";")
                  list_of_children.each do |child_name|
                    next if child_name.blank?
                    new_child = k.camelize.singularize.constantize.find_or_create_by(name: child_name)
                    unless new_object.send(k.downcase.to_sym).exists?(new_child.id)
                      new_object.send(k.downcase.to_sym) << new_child
                    end
                  end
                end
              end
              
            end
          end
        rescue => e
          Rails.env.development? ? byebug : Rails.logger.error(e)
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
