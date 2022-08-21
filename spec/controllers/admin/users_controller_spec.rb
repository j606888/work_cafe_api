require 'rails_helper'

RSpec.describe Admin::UsersController, type: :controller do
  describe 'GET :index' do
    let!(:user) { create(:user) }
    let(:users) { build_list :user, 3 }
    let(:params) do
      {
        page: 2,
        per: 2,
        order: 'desc',
        order_by: 'asc',
      }
    end

    before do
      mock_admin
      allow(UserService::Query).to receive(:call).and_return(users)
    end

    it "pass params to service" do
      get :index, params: params

      expect(response.status).to eq(200)
      expect(UserService::Query).to have_received(:call)
        .with(
          page: params[:page],
          per: params[:per],
          order: params[:order],
          order_by: params[:order_by],
        )
    end
  end
end
