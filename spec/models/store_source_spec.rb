require 'rails_helper'

RSpec.describe StoreSource, type: :model do
  it { should belong_to(:store) }
end
