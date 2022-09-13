class AddTwoAttributesToCountries < ActiveRecord::Migration[5.2]
  def change
    add_column :countries, :attr3, :string
    add_column :countries, :attr4, :integer
  end
end
