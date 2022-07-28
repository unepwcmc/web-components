# frozen_string_literal: true

# TableParameters is a service object class to handle the parameters received in the TableController
# It is also concerned with translating its parameters into SQL (but does not handle executing queries)

class TableParameters
  attr_reader :current_page, :items_per_page, :filters, :sort

  def initialize(**options)
    @current_page = options[:requested_page] || 1
    @items_per_page = options[:items_per_page] || 10
    @filters = options[:filters] || []
    @sort = options[:sort] || {}
  end

  # Turns the active filters into a string of valid SQL to pass to ActiveRecord::QueryMethods#where
  def filters_as_sql
    conditions_array = active_filters.map do |filter|
      name_string = filter['name']
      options_string = convert_options_array_to_sql_syntax(filter['options'])

      "#{name_string} IN #{options_string}"
    end

    conditions_array.join(' AND ')
  end

  # Translates @sort into valid SQL which can by passed to ActiveRecord::QueryMethods#order
  def sort_as_sql
    column = @sort[:column] || 'id'
    direction = @sort[:ascending] == 'true' ? 'ASC' : 'DESC'

    "#{column} #{direction}"
  end

  # get_number_of_pages takes an integer as its argument, which is the number of items in the table
  # It returns the total number of pages for the table, in view of the @items_per_page variable
  def get_number_of_pages(number_of_items)
    return 0 if number_of_items.zero?

    number_of_complete_pages, number_of_leftover_items = number_of_items.divmod(@items_per_page)

    number_of_leftover_items.zero? ? number_of_complete_pages : number_of_complete_pages + 1
  end

  private

  # Takes an array of strings and returns them in SQL array syntax
  # E.g. Array:['cat', 'dog', 'mouse'] => String:"('cat','dog','mouse')"
  def convert_options_array_to_sql_syntax(options_array)
    apostrophised_options = options_array.map { |option_string| "'#{option_string}'" }

    "(#{apostrophised_options.join(',')})"
  end

  def active_filters
    @filters.select { |filter| filter['options'].present? }
  end
end
