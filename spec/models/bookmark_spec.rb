require 'rails_helper'

RSpec.describe Bookmark, type: :model do
  it { should belong_to(:user) }
  it { is_expected.to validate_inclusion_of(:category).in_array(described_class::VALID_CATEGORIES) }
end
