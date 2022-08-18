class DropRolify < ActiveRecord::Migration[7.0]
  def change
    drop_table :roles
    drop_table :users_roles
  end
end
