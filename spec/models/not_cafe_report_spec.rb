require 'rails_helper'

RSpec.describe NotCafeReport, type: :model do
  it { should belong_to(:store) }
  it { should belong_to(:user).optional }
end
