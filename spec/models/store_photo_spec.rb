require 'rails_helper'

RSpec.describe StorePhoto, type: :model do
  it { is_expected.to belong_to(:store) }
end
