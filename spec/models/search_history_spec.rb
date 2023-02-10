require 'rails_helper'

RSpec.describe SearchHistory, type: :model do
  it { should belong_to(:user).optional(true) }
end
