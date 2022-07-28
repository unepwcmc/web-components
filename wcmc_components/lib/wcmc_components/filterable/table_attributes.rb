# frozen_string_literal: true

# TableAttributes is a service object class that can store information about an ActiveModel class's "table attributes"

class TableAttributes
  attr_reader :attributes

  def initialize(attributes_hash = {})
    @attributes = attributes_hash
  end

  # add_attribute is the main method provided to store
  def add_attribute(name, **options)
    @attributes[name] = options
  end

  def filters
    get_attributes_with_options(:filter_on)
  end

  def table_columns
    get_attributes_with_options(:show_in_table)
  end

  def legends
    get_attributes_with_options(:legends)
  end

  def table_columns_and_modal_items
    get_attributes_with_options(:show_in_table, :show_in_modal)
  end

  def table_columns_as_json
    table_columns.map do |column_name, column_options|
      {
        field: column_name,
        title: column_options[:title] || column_name.to_s.gsub(/_/, ' ').capitalize
      }
    end.to_json
  end

  # Return a subset of all attributes; only those which belong to *other* tables
  # E.g. if a country has_one CapitalCity, a listed attribute in the country class could be 'capital_citys.name'
  # Note: This method assumes any attribute containing a '.' to be on an associated table
  def association_attributes
    attributes.select do |key, _value|
      key.to_s.include? '.'
    end
  end

  # A partner to the above method, but returns the names of the tables that the association_attributes belong to.
  # E.g., if a country has attributes 'capital_citys.name', 'capital_citys.population', 'continents.name',
  # this will return ['capital_citys', 'continents'], allowing a #join to be run before querying those attributes
  def association_tables
    associated_attribute_names = association_attributes.keys

    associated_attribute_names.map { |name| name.split('.').first }.uniq
  end

  private

  # A method that will return a subset of @attributes
  # Onely those which have one of options_symbols as a (truthy) key will be returned
  # This method is used by public methods above, e.g. filters, table_columns, etc.
  def get_attributes_with_options(*option_symbols)
    @attributes.select do |_key, value|
      option_symbols.any? { |option_symbol| value[option_symbol] }
    end
  end
end
