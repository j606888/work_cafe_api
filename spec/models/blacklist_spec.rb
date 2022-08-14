require 'rails_helper'

RSpec.describe Blacklist, type: :model do
  it { should validate_presence_of(:keyword) }

  it "validate keyword uniqueness" do
    blacklist = create :blacklist
    
    invalid = build :blacklist, keyword: blacklist.keyword
    expect(invalid).not_to be_valid
  end
end
