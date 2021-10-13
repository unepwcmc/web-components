class CreateMeas < ActiveRecord::Migration[5.2]
  def change
    create_table :meas do |t|
      t.string :name
      t.date :signed

      t.timestamps
    end
  end
end
