require 'rails_helper'

RSpec.describe NewStoreRequest, type: :model do
  it { is_expected.to belong_to(:user) }
end
