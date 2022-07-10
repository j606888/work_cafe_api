require 'rails_helper'

describe GoogleMapPlace, type: :lib do
  describe '#detail' do
    let(:response) { File.read('spec/fixtures/google_map_detail.json') }
    let(:place_id) { 'ChIJ7fkKoZN2bjQRl6TdcFGT-vo' }

    it 'return the respones from detail' do
      stub_request(:post, "https://maps.googleapis.com/maps/api/place/details/json").
        with(query: hash_including({})).
        to_return(body: response, headers: { content_type: 'application/json'})

      res = described_class.detail('ChIJ7fkKoZN2bjQRl6TdcFGT-vo')
      expect(res.name).to eq('國境之南CAFÉ')
      expect(res.place_id).to eq('ChIJ7fkKoZN2bjQRl6TdcFGT-vo')
      expect(res.lat).to eq("22.9948962")
      expect(res.lng).to eq("120.2207877")
      expect(res.url).to eq("https://maps.google.com/?cid=18084929231654855831")
      expect(res.website).to eq("https://www.facebook.com/%E5%9C%8B%E5%A2%83%E4%B9%8B%E5%8D%97%E5%92%96%E5%95%A1%E9%A4%A8-South-of-the-border-cafe-130395073693005/")
      expect(res.address).to eq("701台灣台南市東區大學路18巷16之3號")
      expect(res.rating).to eq(4.2)
      expect(res.phone).to eq("06 275 0384")
      expect(res.user_ratings_total).to eq(109)
      expect(res.city).to eq("台南市")
      expect(res.district).to eq("東區")
      expect(res.open_periods).to eq([
        {
          "close" => { "day" => 0, "time" => "2200" },
          "open" => { "day" => 0, "time" => "1100" }
        },
        {
          "close" => { "day" => 2, "time" => "2200" },
          "open" => { "day" => 2, "time" => "1130" }
        },
        {
          "close" => { "day" => 3, "time" => "2200" },
          "open" => { "day" => 3, "time" => "1130" }
        },
        {
          "close" => { "day" => 4, "time" => "2200" },
          "open" => { "day" => 4, "time" => "1130" }
        },
        {
          "close" => { "day" => 5, "time" => "2200" },
          "open" => { "day" => 5, "time" => "1130" }
        },
        {
          "close" => { "day" => 6, "time" => "2200" },
          "open" => { "day" => 6, "time" => "1100" }
        }
      ])
      expect(res.photos).to eq([
        "AeJbb3fWpsh_zf814gE8erXxvlNnagFutyOUEbX1T4ETbwC91zgTIRHt3tqSp-G8tAaK_hpkVLyzZyrGvnRYOiCFHty3Lpv5-6RtVB8U-8ABFXud8MQnLsEjBBI5q_fcD4kfwphz-NolNzA8rpr8iEzD3dGegVl_T1L0DjvkpwyBwE5zikZC",
        "AeJbb3edtQ76ydIzwDGD64-orXH2NxNcdm6VVltOrpwTygx3DeG8A8P-igFidb8Ip4ZFtJhjwihOK5-Zm0yHUko4PCYeKd6NNud1Qy-dIXffoWyl-h09Z4XImqjNblC4bUpoId119DZ0KrK5Vmf-xRzZkBt47ErGNZp9qj-OiPbaP8VQS7qX",
        "AeJbb3deqy_ZXWJELSJllYztK73mxIJQS93_Khbzdaivht_bHrphw7QKpIck449sxMDMrrgn0HG2-Bg7sYjZsT29jcesvrmyL6xQeMRhIFaTyrrJGruq6U_keuXPVufi96irrOlpxvsGr1vzsjc2TCLuvKShkpvUgaA5sMj4cM5_dtocQzCF",
        "AeJbb3fkSylVx7YcJy8kZ3LJf4lvk2BMy7mDc5r3CP1GCJQQRC9stNps1-EcjSvQTHoI0ihVMFs4ItpS5LFa5BaCK7ge2ncim0N9hpqpydNBuE4J9l1ZqOx4EWcLjGGcoaza7LmMZ7wDBMGeii8jqM_Ozi7KmRQguN3tBd-r77OhuhMNKiI",
        "AeJbb3fzysGEGBkaDLx3tp6mOSJ3E7fWtV0Ag2AzHgxxiL_3nE8HSQfTp9uIWnl7cOV9XWFio4Cu57lSFvcZspIxS6Ue4ANYk3UOKLJiOBlS0_dV5L2SxtI2oyUnvEkMdzxtIrj1U0QkZ4tqWHpmB4vZNl49b6uqslXMN6bsQw77Nww_Qa2a",
        "AeJbb3d3Oo5kw_1HIngSreovyWz5XycO6SskSB-qOZyKxJo9xKXdhaZs3EGx50a6cLytCu0XJ8V578F86i6IceZybyJ5p24MW3IhaZV2ZDUcQj3co-wA-JbWBO0GEEgo9eEKjSVWe-QZFkBK20pzoyyETm-zkoJdq7dfYyxjSahhIi6zyM4H",
        "AeJbb3carnN1M3dfJwB_m0sxx8r3Ugwg62Fc-UOJjgo_E3K-mQHhh4Qzz2eHwwIl9CnYCAcfbShjUeeA1t6XHV10RXPq6mKUe1WtB3Pavv9gq9y2htJ6kcLdVTsC5-05YmPLoScyzhvlkn5HBpfMJqXVK79_ksHgrdBlnqmOcPZoYHJM3o2c",
        "AeJbb3frNNmZPaCOLtV5USms2DhvpGZi6dfO8nvggUDkHyqS3AsWBDx2jNJcLr1w_IR2hd4hQhGAWF5UKZBhlp57_cCpOMXViayD6uUxM2lE57V2uexYwHEKMRs1c7LB0v72aIJPgjooRBlLeaxHvrS4HPUdfBqeU8JNRfCpDjYYPIIBKJgl",
        "AeJbb3edVzcOuk1uCLo0Px9V1NHNtCBfjL3dj7SovfFgWaSsAIg8bVCv2us2Cv85OiFK3vpXJWiE0abxWv-KCDCBlC-UYC_IqaJuCFaj0UOX-jde8OTj_vGko6bSmqoxBf2Z831-Wrph4fzwqoI8iPlvMqx_KayCWPyUq1BcFRibBdI8guaI",
        "AeJbb3dr4Qn5zoAzTqmXk82JSyLVFywewRrsfiup9GZI8jgQU7lbSwoo9rXmj04zioFYUJF8EoVU3t_-i4Lq4C_kIpoBmtyzpwN6NNNIr3PcSaYDbJEjAYm5Pc4WDggLSslC451JAHF0y_dD64q7XjtVgdoYOZhWW8MRgiEtL2fDQCt3uNEn"
      ])
    end
  end

  describe '#detail' do
    let(:response) { File.read('spec/fixtures/google_map_nearbysearch.json') }
    let(:params) do
      {
        location: '23.0036324,120.2070514',
        keyword: '鴨母聊·亞捷咖啡',
        radius: 3000
      }
    end

    it 'return the respones from nearbysearch' do
      stub_request(:post, "https://maps.googleapis.com/maps/api/place/nearbysearch/json").
        with(query: hash_including({})).
        to_return(body: response, headers: { content_type: 'application/json'})

      res = described_class.nearbysearch(**params)
      expect(res.name).to eq('鴨母聊·亞捷咖啡')
      expect(res.place_id).to eq('ChIJ93sCR2B2bjQRxHwccpKTVvg')
      expect(res.types).to eq(["cafe", "store", "food", "point_of_interest", "establishment"])
    end
  end

  describe '#cafe_search' do
    let(:response) { File.read('spec/fixtures/google_map_cafe_search.json') }
    let(:params) do
      {
        location: '22.9994438,120.2048099',
        radius: 1000
      }
    end

    it 'return the response from cafe_search' do
      stub_request(:post, "https://maps.googleapis.com/maps/api/place/nearbysearch/json").
        with(query: hash_including({})).
        to_return(body: response, headers: { content_type: 'application/json'})

      res = described_class.cafe_search(**params)
      expect(res.next_page_token).to eq(nil)
      expect(res.places).to match_array(
        [
          {:place_id=>"ChIJKQvNlYl2bjQRGZCMHUi--u4", :name=>"Gan Dan Cafe"},
          {:place_id=>"ChIJM6N9rGB2bjQRkY1hO7ff48A", :name=>"Golden Tulip Glory Fine Hotel Tainan"},
          {:place_id=>"ChIJQVhy5GB2bjQRbCKCXlnzXX0", :name=>"卡加米亞casamia cafe"},
          {:place_id=>"ChIJhwhoW2N2bjQRsQRMoD4STa4", :name=>"Shuangquan Black Tea"},
          {:place_id=>"ChIJxRCBpYx2bjQRC4PhjOObSjY", :name=>"Tian Zaixin Cafe"},
          {:place_id=>"ChIJyeyC9It2bjQRJ3ooaDY30IU", :name=>"STARBUCKS Tainan Shop"},
          {:place_id=>"ChIJCW1KM2J2bjQRTzRcbj-PJBk", :name=>"倫敦唐寧街十號"},
          {:place_id=>"ChIJFU-rqIl2bjQRyyL1zmacA-w", :name=>"小巷裡的拾壹號"},
          {:place_id=>"ChIJZfZad2F2bjQRnjbW5fnsKzE", :name=>"ITSO"},
          {:place_id=>"ChIJPyVjsYx2bjQRLo1DaoZpW2E", :name=>"雨露微亮 everiridescent"},
          {:place_id=>"ChIJd4-t8ox2bjQR3VsxHRBKnHk", :name=>"My Beverages"},
          {:place_id=>"ChIJoYY-W2N2bjQRL-cmd9pDwCs", :name=>"Suehiro-cho maid cafe"},
          {:place_id=>"ChIJBwhM54l2bjQRbGGXC4JkHzQ", :name=>"B.B.ART"},
          {:place_id=>"ChIJP1Mra4l2bjQRMvTvyle_pCw", :name=>"ALFEE Coffee 台南艾咖啡"},
          {:place_id=>"ChIJKSejlIl2bjQR0R5HFKGTPSU", :name=>"Laos Coffee"},
          {:place_id=>"ChIJI1Ek6Il2bjQRQwgo6OUUle4", :name=>"Daybreak 18 Teahouse"},
          {:place_id=>"ChIJ-cosJWd2bjQR6MgmBgBySNw", :name=>"CT Life小日子"},
          {:place_id=>"ChIJfR36xGN2bjQRj3Vx8oMdgV0", :name=>"意的咖啡名店"}
        ]
      )
    end
  end
end
