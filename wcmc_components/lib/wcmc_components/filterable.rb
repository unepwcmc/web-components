require 'wcmc_components/filterable/attributes'
require 'wcmc_components/filterable/csv_generator'
require 'wcmc_components/filterable/parameters'
require 'wcmc_components/filterable/query_object'
require 'wcmc_components/filterable/serializer'

module WcmcComponents
  module Filterable
    extend ActiveSupport::Concern

    included do
      class_attribute :table_attributes, default: Attributes.new

      delegate :form_attributes, :table_columns, :attributes_for_table, to: :table_attributes

      # Callback method to take values from a dynamically defined instance variable that
      # holds a ; separated string of values used to build the associated records.
      before_save :build_associations

      # table_page_path returns the 'show' path for the resource
      def table_page_path
        "#{base_path}/#{id}"
      end

      # TODO: is there a better way to do this
      def table_edit_path
        "#{base_path}/#{id}/edit"
      end

      def table_archive_path
        "#{base_path}/#{id}/archive"
      end

      def build_associations
        # Rebuilds associations from the ; separated string of values in the dynamically defined instance variable.
        table_attributes.association_attributes.each do |association_attribute|
          table_name, attribute_name = association_attribute[0].to_s.split('.')
          self.send(table_name).clear

          accessor_method_name = "#{table_name}_#{attribute_name.pluralize}"
          self.send(accessor_method_name).split(';').each do |value|
            params = {}
            params[attribute_name.to_sym] = value.strip
            self.send(table_name) << table_name.classify.constantize.find_or_create_by(params)
          end
        end
      end
    end

    def base_path
      "/#{self.class.name.tableize}"
    end

    class_methods do
      delegate :attributes_for_table,
        :csv_attributes,
        :table_filters,
        :table_legends,
        :table_columns,
        to: :table_attributes

      def add_form_methods_for_associated_records
        table_attributes.association_attributes.each do |association_attribute|
          define_additional_form_methods_for_association(association_attribute[0])
        end
      end

      def define_additional_form_methods_for_association(name)
        # Dynamically define methods to be used for hacking the form to work with multiple associations.
        table_name, attribute_name = name.to_s.split('.')
        accessor_method_name = "#{table_name}_#{attribute_name.pluralize}"
        instance_variable_name = "@#{accessor_method_name}"

        define_method(accessor_method_name) do
          instance_variable_get(instance_variable_name) ||
          instance_variable_set(instance_variable_name, self.send(table_name).map(&attribute_name.to_sym).join(';'))
        end

        define_method("#{accessor_method_name}=") do |value|
          instance_variable_set(instance_variable_name, value)
        end
      end

      def table_filters_with_options
        table_filters(self.all)
      end

      def table_legends_with_options
        table_legends(self.all)
      end

      # table_attribute is a wrapper for TableAttributes#add_attribute
      # Use this in the class definition to add an attribute
      def table_attribute(name, **options)
        table_attributes.add_attribute(name, options)
      end

      # The primary entrypoint method for serializing items of the base class for use in the FilterableTable component
      def paginate_for_table(**table_parameter_options)
        paginate(table_parameter_options, 'table')
      end

      def paginate_for_api(api_parameter_options)
        paginate(api_parameter_options, 'api')
      end

      def paginate(parameter_options, type)
        parameters = Parameters.new(**parameter_options, active_record_class: self)
        query = get_query_object(parameters, true)

        Serializer.new(parameters).send(
          "serialize_relation_for_#{type}",
          { total: query.total, results: query.result }
        )
      end

      def to_csv(parameter_options)
        parameters = Parameters.new(**parameter_options, active_record_class: self)
        query = get_query_object(parameters)

        CsvGenerator.new(query.result).to_csv(csv_attributes)
      end

      def csv_filename
        "#{name.tableize}_#{Date.today.to_s}.csv"
      end

      def get_query_object(parameters, paginate = false)
        query = QueryObject.new(self)
        
        query.query_with_filterable_parameters(parameters)

        query.paginate(parameters) if paginate

        query
      end

      def columns_to_json
        table_attributes.table_columns
      end
    end
  end
end
