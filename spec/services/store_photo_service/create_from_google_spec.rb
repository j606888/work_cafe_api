require 'rails_helper'

describe StorePhotoService::CreateFromGoogle do
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

  before do
    allow(GoogleMapPlace).to receive(:photo).and_return('image-content')
    allow(Aws::S3::Client).to receive(:new).and_return(mock_s3)
  end

  it "init with required attr" do
    described_class.new(store_id: store.id)
  end

  it "fill up Store#image_url with first photo" do
    store = service.perform
    first_photo = store.store_photos.first

    key = "stores/#{store.place_id}/#{first_photo.random_key}.jpeg"
    expect(store.image_url).to eq("#{described_class::S3_PREFIX}#{key}")
  end

  it "call GoogleMapPlace.photo" do
    service.perform

    ['ref-1', 'ref-2', 'ref-3'].each do |ref|
      expect(GoogleMapPlace).to have_received(:photo).with(ref)
    end
  end

  it "upload photo to AWS.S3" do
    store = service.perform

    store.store_photos.each do |photo|
      expect(mock_s3).to have_received(:put_object).with(
        bucket: described_class::S3_BUCKET,
        key: "stores/#{store.place_id}/#{photo.random_key}.jpeg",
        body: 'image-content',
        content_type: 'image/jpeg'
      )
    end
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

  # context 'when limit is provide' do
  #   let(:service) { described_class.new(store_id: store.id, limit: 1) }

  #   it 'only retrieve 1 photo' do
  #     service.perform

  #     expect(GoogleMapPlace).to have_received(:photo).with('ref-1')
  #     expect(GoogleMapPlace).not_to have_received(:photo).with('ref-2')
  #     expect(GoogleMapPlace).not_to have_received(:photo).with('ref-3')
  #   end
  # end

  it "raise error if store_source not exist" do
    store_source.delete

    expect { service.perform }.to raise_error(Service::PerformFailed)
  end
end
