require 'rails_helper'

RSpec.describe ChainStoreMap, type: :model do
    it { should belong_to(:chain_store) }
    it { should belong_to(:store) }
end
