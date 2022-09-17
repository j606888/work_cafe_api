require 'rails_helper'

describe StorePhotoService::CreatePresignedUrl do
  let!(:store) { create :store }
  let(:params) do
    {
      store_id: store.id
    }
  end
  let(:service) { described_class.new(**params) }
  let(:mock_s3_object) { double(presigned_url: 'some-link')}
  let(:mock_s3_bucket) { double(object: mock_s3_object) }

  before do
    allow(SecureRandom).to receive(:hex).and_return('some-random-key')
    allow(Aws::S3::Bucket).to receive(:new).and_return(mock_s3_bucket)
  end

  it 'takes required attributes to initialize' do
    described_class.new(store_id: 2)
  end

  it 'assign object_key to s3' do
    res = service.perform
  
    expect(mock_s3_bucket).to have_received(:object)
      .with("stores/#{store.place_id}/some-random-key.jpg")
    expect(mock_s3_object).to have_received(:presigned_url)
      .with(:put, acl: 'public-read')
    expect(res).to eq('some-link')
  end
end
