class DropTableNewStoreRequests < ActiveRecord::Migration[7.0]
  def change
    drop_table :new_store_requests
  end
end
