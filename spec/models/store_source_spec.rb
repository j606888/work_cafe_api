require 'rails_helper'

RSpec.describe StoreSource, type: :model do
  it { should validate_inclusion_of(:create_type).in_array(described_class::VALID_CREATE_TYPE) }
  it "should validate uniqueness of :place_id" do
    store_source = create :store_source, {
      place_id: 'some_place_id'
    }

    invalid = build :store_source, {
      place_id: store_source.place_id
    }
    expect(invalid).not_to be_valid

    invalid.place_id = store_source.place_id + 'more_text'
    expect(invalid).to be_valid
  end
end
