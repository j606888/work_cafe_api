require 'rails_helper'

RSpec.describe BookmarkStore, type: :model do
  it { should belong_to(:bookmark) }
  it { should belong_to(:store) }
end
