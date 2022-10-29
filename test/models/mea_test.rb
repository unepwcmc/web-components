require 'test_helper'

class MeaTest < ActiveSupport::TestCase
  test 'HABTM relationship' do
    Country.import 'good_countries.csv'
    Mea.import 'good_meas.csv'
    assert_equal 2, Mea.count
    uk = Country.find_by(name: 'United Kingdom')
    assert_equal 2, Mea.joins(:countries).where(countries: { id: uk.id }).count
    fr = Country.find_by(name: 'France')
    assert_equal 1, Mea.joins(:countries).where(countries: { id: fr.id }).count
  end

  test 'multiple select filter on habtm - no filter' do
    Country.import 'good_countries.csv'
    Mea.import 'good_meas.csv'

    meas = Mea.paginate_for_table()
    assert_equal 2, meas[:items].count
  end

  # TODO: TEST FILTERING ON MEA ID

  test 'multiple select filter on habtm - single filter' do
    Country.import 'good_countries.csv'
    Mea.import 'good_meas.csv'

    meas = Mea.paginate_for_table(**{
      filters: [
        {
          name: "countries.name",
          options: [
            "France"
          ],
          type: "multiple"
        }
      ],
      items_per_page: 15,
      requested_page: 1
    })

    assert_equal 1, meas[:items].count
  end
end
