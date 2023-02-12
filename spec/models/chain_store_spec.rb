require 'rails_helper'

RSpec.describe ChainStore, type: :model do
  it { should validate_presence_of(:name) }
end
