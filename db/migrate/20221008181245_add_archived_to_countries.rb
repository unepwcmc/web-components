class AddArchivedToCountries < ActiveRecord::Migration[5.2]
  def change
    add_column :countries, :archived, :boolean
  end
end
