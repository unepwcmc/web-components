require 'test_helper'

class ProjectTest < ActiveSupport::TestCase

  test "import belongs to relation" do
    Country.import "good_countries.csv"
    Project.import "good_projects.csv"
    assert_equal 3, Project.count
    uk = Country.find_by(name: "United Kingdom")
    assert_equal 2, Project.where(country: uk).count
  end
end
