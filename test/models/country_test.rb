require 'test_helper'
require 'wcmc_components'

class CountryTest < ActiveSupport::TestCase
  test "csv file path" do
    # test defaults to plural, lowercase
    assert_equal Country.csv_file_path, Rails.root.join('test', 'seeds', 'countries.csv')
    # test environment switching
    begin
      Rails.env = "development"
      assert_equal Country.csv_file_path, Rails.root.join('lib', 'data', 'seeds', 'countries.csv')
    ensure
      Rails.env = "test"
    end
    # test overriding
    assert_equal Country.csv_file_path("override.csv"), Rails.root.join('test', 'seeds', 'override.csv')
  end

  test "simple ASCII csv import" do
    Country.import "good_countries.csv"
    assert_equal 2, Country.count
  end
  test "simple UTF-8 csv import" do
    Country.import "utf8_countries.csv"
    assert_equal 3, Country.count
  end

  test "filter config" do
    assert_equal 2, Country.filters.count
  end

  test "filter to json" do
    Country.import "good_countries.csv"
#    puts Country.filters_to_json
    f = JSON.parse Country.filters_to_json
    assert_equal "name", f[0]['name']
    assert_equal "Name", f[0]['title']
    assert_equal 2, f[0]['options'].count
    assert_equal "single", f[0]['type']
    # test overriding title
    assert_equal "ISO 3 Code", f[1]['title']
  end
  
  
end
