class CreateJoinTableMeaCountry < ActiveRecord::Migration[5.2]
  def change
    create_join_table :meas, :countries do |t|
      t.index %i[mea_id country_id]
      t.index %i[country_id mea_id]
    end
  end
end
