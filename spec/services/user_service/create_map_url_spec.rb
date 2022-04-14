require 'rails_helper'

describe UserService::CreateMapUrl do
  describe '::new()' do
    it 'init with desired parameters' do
      UserService::CreateMapUrl.new(
        user_id: 1,
        url: 'some_url'
      )
    end 
  end

  describe '#perform' do
    let!(:user) { FactoryBot.create :user }
    let(:params) do
      {
        user_id: user.id,
        url: "https://www.google.com.tw/maps/place/%E6%A4%92%E5%AD%B8%E9%A4%A8%E9%8D%8B%E7%89%A9%E6%96%99%E7%90%86/@22.9977124,120.2291194,14.63z/data=!4m5!3m4!1s0x0:0xd72f3c2a470622bc!8m2!3d22.9925209!4d120.2208513?hl=zh-TW"
      }
    end
    
    let(:service) { described_class.new(**params) }

    it 'should create a new map_url' do
      map_url = service.perform

      expect(map_url.user_id).to eq(user.id)
      expect(map_url.url).to eq(params[:url])
      expect(map_url.keyword).to eq("椒學館鍋物料理")
    end
  end
end
