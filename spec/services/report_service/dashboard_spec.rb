require 'rails_helper'

describe ReportService::Dashboard do
  let(:params) do
    {

    }
  end
  let(:service) { described_class.new(**params) }

  it 'takes required attributes to initialize' do
    described_class.new()
  end
end
