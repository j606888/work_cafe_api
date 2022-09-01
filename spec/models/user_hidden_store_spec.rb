require 'rails_helper'

RSpec.describe UserHiddenStore, type: :model do
  it "validate unique for user & store" do
    user = create :user
    store = create :store

    user_hidden_store = create :user_hidden_store, user: user, store: store
    invalid = build :user_hidden_store, user: user, store: store

    expect(invalid).not_to be_valid
  end
end
