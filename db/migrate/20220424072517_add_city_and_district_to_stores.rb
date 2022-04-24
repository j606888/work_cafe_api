class AddCityAndDistrictToStores < ActiveRecord::Migration[7.0]
  def change
    add_column :stores, :city, :string
    add_column :stores, :district, :string
  end
end
