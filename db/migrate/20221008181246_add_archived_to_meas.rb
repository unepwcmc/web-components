class AddArchivedToMeas < ActiveRecord::Migration[5.2]
  def change
    add_column :meas, :archived, :boolean
  end
end
