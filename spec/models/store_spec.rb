require 'rails_helper'

RSpec.describe Store, type: :model do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:url) }
  it { should belong_to(:map_url) }
end
