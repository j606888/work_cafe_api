require 'rails_helper'

RSpec.describe StorePhotoGroup, type: :model do
  it "validate unique for user & store" do
    user = create :user
    store = create :store

    store_photo_group = create :store_photo_group, user: user, store: store
    invalid = build :store_photo_group, user: user, store: store

    expect(invalid).not_to be_valid
  end
end
