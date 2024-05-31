require 'rails_helper'

RSpec.describe "SecureData", type: :request do
  include FactoryBot::Syntax::Methods
  describe "GET /secure_data" do
    let(:user) {create(:user) }
    let(:token) {JWT.encode({ user_id: user.id }, 'your_secret_key') }

    context "with a valid token" do
      it "returns secure data" do
        get '/secure_data', headers: { Authorization: "Bearer #{token}" }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['data']).to eq('This is secure data')
      end
    end
  end
end
