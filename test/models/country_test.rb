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
end
