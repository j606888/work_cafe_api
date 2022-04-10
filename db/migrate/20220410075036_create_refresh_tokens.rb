class CreateRefreshTokens < ActiveRecord::Migration[7.0]
  def change
    create_table :refresh_tokens do |t|
      t.references :user, null: false, foreign_key: true
      t.string :token, null: false, unique: true
      t.boolean :is_valid, null: false, default: true

      t.timestamps
    end
  end
end
