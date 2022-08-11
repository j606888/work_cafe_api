require 'rails_helper'

describe StoreService::FetchPhoto do
  let!(:store) { create :store }
  let!(:store_source) do
    create :store_source, {
      store: store,
      source_data: {
        'photos' => [
          { 'photo_reference' => 'ref-1' },
          { 'photo_reference' => 'ref-2' },
          { 'photo_reference' => 'ref-3' }
        ]
      }
    }
  end
  let(:mock_s3) { double(put_object: true) }
  let(:service) { described_class.new(store_id: store.id) }
  let(:mock_body) { double(body: 'image-content') }

  before do
    allow(GoogleMapPlace).to receive(:photo).and_return(mock_body)
    allow(Aws::S3::Client).to receive(:new).and_return(mock_s3)
  end

  it "init with required attr" do
    described_class.new(store_id: store.id)
  end

  it "fill up Store#image_url" do
    store = service.perform

    expect(store.image_url).to eq("#{described_class::S3_PREFIX}stores/#{store.place_id}.jpeg")
  end

  it "call GoogleMapPlace.photo" do
    service.perform

    expect(GoogleMapPlace).to have_received(:photo).with('ref-1')
  end

  it "upload photo to AWS.S3" do
    service.perform

    expect(mock_s3).to have_received(:put_object).with(
      bucket: described_class::S3_BUCKET,
      key: "stores/#{store.place_id}.jpeg",
      body: mock_body,
      content_type: 'image/jpeg'
    )
  end

  context "when photo_reference is empty" do
    before do
      store_source.update!(
        source_data: {}
      )
    end

    it "won't create & assign photo" do
      service.perform

      expect(GoogleMapPlace).not_to have_received(:photo)
      expect(Aws::S3::Client).not_to have_received(:new)
    end
  end

  it "raise error if store_source not exist" do
    store_source.delete

    expect { service.perform }.to raise_error(Service::PerformFailed)
  end
end
