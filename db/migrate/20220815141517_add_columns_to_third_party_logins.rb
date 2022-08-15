class AddColumnsToThirdPartyLogins < ActiveRecord::Migration[7.0]
  def change
    add_column :third_party_logins, :identity, :string, null: false, unique: true
  end
end
