class DropTableHidden < ActiveRecord::Migration[7.0]
  def change
    drop_table :hiddens
  end
end
