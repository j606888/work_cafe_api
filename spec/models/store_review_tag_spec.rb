require 'rails_helper'

RSpec.describe StoreReviewTag, type: :model do
  it { should belong_to(:store) }
  it { should belong_to(:review) }
  it { should belong_to(:tag) }
end
