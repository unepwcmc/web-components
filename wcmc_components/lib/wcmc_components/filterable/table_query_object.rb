class TableQueryObject
  # Initialize with the active record class that you wish to query, e.g. Country
  def initialize(active_record_class)
    @active_record_class = active_record_class
  end

  # query_with_table_parameters expects an instance of TableParameters
  # it returns a Array of instances of @active_record_class all of which satisfy the conditions in table_parameters
  def query_with_table_parameters(table_parameters)
    association_tables = @active_record_class.table_attributes.association_tables
    where_statement = table_parameters.filters_as_sql
    order_statement = table_parameters.sort_as_sql

    @active_record_class.joins(association_tables).where(where_statement).order(order_statement)
  end
end
