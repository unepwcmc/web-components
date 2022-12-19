require 'test_helper'
require 'wcmc_components'

class CountryTest < ActiveSupport::TestCase
  test 'csv file path' do
    # test defaults to plural, lowercase
    assert_equal Country.csv_file_path, Rails.root.join('test', 'seeds', 'countries.csv')
    # test environment switching
    begin
      Rails.env = 'development'
      assert_equal Country.csv_file_path, Rails.root.join('lib', 'data', 'seeds', 'countries.csv')
    ensure
      Rails.env = 'test'
    end
    # test overriding
    assert_equal Country.csv_file_path('override.csv'), Rails.root.join('test', 'seeds', 'override.csv')
  end

  test 'simple ASCII csv import' do
    Country.import 'good_countries.csv'
    assert_equal 2, Country.count
  end
  test 'simple UTF-8 csv import' do
    Country.import 'utf8_countries.csv'
    assert_equal 3, Country.count
  end

  test 'filter config' do
    assert_equal 4, Country.table_filters_with_options.count
  end

  test 'filters for table' do
    Country.import 'good_countries.csv'
    filters = Country.table_filters_with_options

    assert_equal 'iso3', filters[0][:name]
    assert_equal 'ISO 3 Code', filters[0][:title]
    assert_equal 2, filters[0][:options].count
    assert_equal 'single', filters[0][:type]
    # test overriding title
    assert_equal 'Name', filters[1][:title]
  end

  # By default countries are in reverse id order (most recent first)
  test 'first page pagination' do
    initialize_countries(25)

    c = Country.paginate_for_table
    assert_equal 10, c[:items].count
    assert_equal 'C25', get_country_iso_from_item(c[:items][0])
    # FIXME: include this test - should be fixed by feat/edit-styling
    # assert_equal "/country/#{c[:items][0][:cells][0][:value]}/", c[:items][0][:pageUrl]
    assert_equal 'C16', get_country_iso_from_item(c[:items][9])
  end

  test 'second page pagination' do
    initialize_countries(25)

    c = Country.paginate_for_table(requested_page: 2)
    assert_equal 10, c[:items].count
    assert_equal 'C15', get_country_iso_from_item(c[:items][0])
    assert_equal 'C06', get_country_iso_from_item(c[:items][9])
  end

  test 'final page pagination' do
    initialize_countries(25)

    c = Country.paginate_for_table(requested_page: 3)
    assert_equal 5, c[:items].count
    assert_equal 'C05', get_country_iso_from_item(c[:items][0])
    assert_equal 'C01', get_country_iso_from_item(c[:items][4])
  end

  test 'change page size pagination' do
    initialize_countries(25)

    c = Country.paginate_for_table(items_per_page: 7)
    assert_equal 7, c[:items].count
  end

  test 'sort by record attribute' do
    Country.import 'good_countries.csv'

    c_asc = Country.paginate_for_table(sort: { column: 'iso3', ascending: 'true' })
    c_desc = Country.paginate_for_table(sort: { column: 'iso3', ascending: 'false' })

    assert_equal 'FRA', get_country_iso_from_item(c_asc[:items][0])
    assert_equal 'GBR', get_country_iso_from_item(c_desc[:items][0])
  end

  private

  def initialize_countries(n)
    FactoryBot.rewind_sequences

    Array(1..n).each do |_n|
      FactoryBot.build(:country).save
    end
  end

  def get_country_iso_from_item(item)
    item[:cells].select { |cell| cell[:name] == 'iso3' }[0][:value]
  end
end
