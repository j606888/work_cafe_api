class CreateThirdPartyLogins < ActiveRecord::Migration[7.0]
  def change
    create_table :third_party_logins do |t|
      t.references :user, null: false, foreign_key: true
      t.string :email, null: false
      t.string :provider, null: false

      t.timestamps
    end
  end
end
