require 'rails_helper'

RSpec.describe "Widgets", type: :request do
  include FactoryBot::Syntax::Methods

  let!(:user) { create(:user) }
  let(:token) { JWT.encode({ user_id: user.id }, 'your_secret_key') }

  before do
    Widget.create(id: 1, name: 'Foo')
    Widget.create(id: 2, name: 'Bar')
    Widget.create(id: 3, name: 'Baz')
  end

  describe "GET /api/widgets" do
    context "with a valid token" do
      it "returns a list of specific widgets" do
        get '/api/widgets', headers: { Authorization: "Bearer #{token}" }

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to eq(
          [
            { 'id' => 1, 'name' => 'Foo' },
            { 'id' => 2, 'name' => 'Bar' },
            { 'id' => 3, 'name' => 'Baz' }
          ]
        )
      end
    end

    context "with an invalid token" do
      it "returns an unauthorized error" do
        get '/api/widgets', headers: { Authorization: "Bearer invalidtoken" }

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)['error']).to eq('Unauthorized')
      end
    end
  end
end
