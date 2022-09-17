require 'rails_helper'

RSpec.describe StorePhoto, type: :model do
  it { is_expected.to belong_to(:store) }
  it { is_expected.to belong_to(:user).optional }
end
