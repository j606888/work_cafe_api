require 'rails_helper'

RSpec.describe Hidden, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:store) }

  it 'should validate uniquness of user_id & store_id' do
    exist = FactoryBot.create :hidden
    
    invalid = FactoryBot.build :hidden, {
      user_id: exist.user_id,
      store_id: exist.store_id
    }
    expect(invalid).not_to be_valid
  end
end
