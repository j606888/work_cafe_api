require 'rails_helper'

RSpec.describe Store, type: :model do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:place_id) }
  it { should validate_presence_of(:url) }

  it 'should validate uniqueness of exnteral_id' do
    place = FactoryBot.create :store
    invalid = FactoryBot.build :store, place_id: place.place_id

    expect(invalid).not_to be_valid
  end
end
