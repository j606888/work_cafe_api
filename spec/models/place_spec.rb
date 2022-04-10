require 'rails_helper'

RSpec.describe Place, type: :model do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:external_id) }
  it { should validate_presence_of(:url) }

  it 'should validate uniqueness of exnteral_id' do
    place = FactoryBot.create :place
    invalid = FactoryBot.build :place, external_id: place.external_id

    expect(invalid).not_to be_valid
  end
end
