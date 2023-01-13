require 'test_helper'

MEAS_COUNT = 3

class MeaTest < ActiveSupport::TestCase
  test 'HABTM relationship' do
    Country.import 'good_countries.csv'
    Mea.import 'good_meas.csv'
    assert_equal MEAS_COUNT, Mea.count
    uk = Country.find_by(name: 'United Kingdom')
    assert_equal 2, Mea.joins(:countries).where(countries: { id: uk.id }).count
    fr = Country.find_by(name: 'France')
    assert_equal 1, Mea.joins(:countries).where(countries: { id: fr.id }).count
  end

  test 'multiple select filter on habtm - no filter' do
    Country.import 'good_countries.csv'
    Mea.import 'good_meas.csv'

    meas = Mea.paginate_for_table()
    assert_equal MEAS_COUNT, meas[:items].count
  end

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

  test 'select type single filter on model' do
    Country.import 'good_countries.csv'
    Mea.import 'good_meas.csv'

    meas = Mea.paginate_for_table(**{
      filters: [
        {
          name: "name",
          options: [
            "Convention on Semicolons"
          ],
          type: "single"
        }
      ]
    })

    assert_equal 1, meas[:items].count
  end

  test 'sort by unsortable attribute' do
    Country.import 'good_countries.csv'
    Mea.import 'good_meas.csv'

    m_asc = Mea.paginate_for_table(sort: { column: 'countries.name', ascending: 'true' })
    m_desc = Mea.paginate_for_table(sort: { column: 'countries.name', ascending: 'false' })

    assert_equal 'International Committee for the UK', get_mea_name_from_item(m_asc[:items][0])
    assert_equal 'International Committee for the UK', get_mea_name_from_item(m_desc[:items][0])
  end

  private

  def get_mea_name_from_item(item)
    id = item[:cells].select { |cell| cell[:name] == 'id' }[0][:value]
    
    Mea.find(id).name
  end
end
