require 'test_helper'

class TableControllerTest < ActionDispatch::IntegrationTest
  test "should post list" do
    Mea.import "good_meas.csv"

    post '/meas'
    assert_response :success
    assert_total 2
  end
  
  test "should get second engine list" do
    Country.import "good_countries.csv"

    post '/countries'
    assert_response :success
    assert_total 2
  end

  test "with basic filter" do
    Country.import "good_countries.csv"

    post '/countries', params: { requested_page: 1,
                                 filters: [ name: 'iso3', options: ['GBR'] ]}
    assert_response :success
    assert_total 1
  end

  
  # helper methods to assert on table results
  
  def assert_total (expected)
    json = JSON.parse(response.body)
    assert_equal expected, json['total_entries']
  end
end
