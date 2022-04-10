require 'rails_helper'

RSpec.describe Place, type: :model do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:external_id) }
  it { should validate_presence_of(:url) }
end
