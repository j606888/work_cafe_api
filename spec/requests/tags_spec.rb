require 'rails_helper'

RSpec.describe "Tags", type: :request do
  describe "GET /tags" do
    let!(:tags) { create_list :tag, 5 }

    it "query all tags" do
      get "/tags"

      expect(response.status).to eq(200)
      res_hash = JSON.parse(response.body)
      res_hash.each_with_index do |t, index|
        expect(t['id']).to eq(tags[index].id)
        expect(t['name']).to eq(tags[index].name)
      end
    end
  end
end
