class AddSourceableToStores < ActiveRecord::Migration[7.0]
  def up
    change_table :stores do |t|
      t.references :sourceable, polymorphic: true
    end
  end

  def down
    change_table :stores do |t|
      t.remove_references :sourceable, polymorphic: true
    end
  end
end
