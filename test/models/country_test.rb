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

  test "all_to_json" do
    Country.import "good_countries.csv"
    c = JSON.parse Country.all_to_json
    assert_equal 2, c.count
    assert_equal "United Kingdom", c[0]['name']
    assert_equal "FRA", c[1]['iso3']
  end

  test "first page pagination" do
    FactoryBot.rewind_sequences
    
    Array(1..25).each {|n|
      FactoryBot.build(:country).save
    }
    c = Country.paginate("{}")
    assert_equal 10, c[:items].count
    assert_equal "C01",  c[:items][0][:cells][2][:value]
    assert_equal "/country/#{c[:items][0][:cells][0][:value]}/",  c[:items][0][:pageUrl]
    assert_equal "C10",  c[:items][9][:cells][2][:value]
  end

  test "second page pagination" do
    FactoryBot.rewind_sequences
    Array(1..25).each {|n|
      FactoryBot.build(:country).save
    }

    c = Country.paginate({'requested_page' => 2}.to_json)
    assert_equal 10, c[:items].count
    assert_equal "C11",  c[:items][0][:cells][2][:value]
    assert_equal "C20",  c[:items][9][:cells][2][:value]
  end

  test "final page pagination" do
    FactoryBot.rewind_sequences
    Array(1..25).each {|n|
      FactoryBot.build(:country).save
    }

    c = Country.paginate({'requested_page' => 3}.to_json)
    assert_equal 5, c[:items].count
    assert_equal "C21",  c[:items][0][:cells][2][:value]
    assert_equal "C25",  c[:items][4][:cells][2][:value]
  end

  test "change page size pagination" do
    FactoryBot.rewind_sequences
    
    Array(1..25).each {|n|
      FactoryBot.build(:country).save
    }

    c = Country.paginate({'items_per_page' => 7}.to_json)
    assert_equal 7, c[:items].count
  end

  
end
