require 'rails_helper'

RSpec.describe Blacklist, type: :model do
  it { should validate_presence_of(:keyword) }

  it "validate keyword uniqueness" do
    blacklist = create :blacklist
    
    invalid = build :blacklist, keyword: blacklist.keyword
    expect(invalid).not_to be_valid
  end

  describe '#self.keywords' do
    it 'return [] by default' do
      res = described_class.keywords

      expect(res).to eq([])
    end

    it 'return all keywords' do
      blacklists = create_list :blacklist, 3

      res = described_class.keywords

      expect(res.length).to eq(3)
      expect(res).to eq(blacklists.map(&:keyword))
    end
  end
end
