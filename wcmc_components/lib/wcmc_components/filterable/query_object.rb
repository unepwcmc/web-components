module WcmcComponents
  module Filterable
    class QueryObject
      # Initialize with the active record class that you wish to query, e.g. Country
      def initialize(active_record_class)
        @active_record_class = active_record_class
      end

      # query_with_filterable_parameters expects an instance of Filterable::Parameters
      # it returns a Array of instances of @active_record_class all of which satisfy the conditions in filterable_parameters
      def query_with_filterable_parameters(filterable_parameters)
        association_tables = @active_record_class.table_attributes.association_tables
        where_statement = filterable_parameters.filters_as_sql
        order_statement = filterable_parameters.sort_as_sql

        @active_record_class.joins(association_tables)
          .where(where_statement)
          .order(order_statement)
          .offset(filterable_parameters.sql_offset)
          .limit(filterable_parameters.sql_limit)
      end
    end
  end
end
