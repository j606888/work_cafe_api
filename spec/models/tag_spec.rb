require 'rails_helper'

RSpec.describe Tag, type: :model do
  it "validate uniqueness of name" do
    tag = create :tag
    invalid = build :tag, name: tag.name

    expect(invalid).not_to be_valid
  end
end
