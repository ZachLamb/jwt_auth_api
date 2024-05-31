require 'rails_helper'

RSpec.describe "Auth", type: :request do
    include FactoryBot::Syntax::Methods
    describe "POST /api/register" do
    context "with valid parameters" do
      let(:valid_attributes) { { email: "john@form.com", password: "password"} }

      it "creates a new user" do
        expect {
          post '/api/register', params: valid_attributes
        }.to change(User, :count).by(1)
      end

      it "returns a success message" do
        post '/api/register', params: valid_attributes
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)).to have_key('token')
      end
    end

    context "with invalid parameters" do
      let(:invalid_attributes) { { email: "john@form.com", password: "", } }

      it "does not create a new user" do
        expect {
          post '/api/register', params: invalid_attributes
        }.to change(User, :count).by(0)
      end

      it "returns error messages" do
        post '/api/register', params: invalid_attributes
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['errors']).to include("Password can't be blank")
      end
    end
  end

  describe "POST /api/login" do
    let!(:user) { create(:user, email: "john@form.com", password: "password") }

    context "with valid credentials" do
      let(:valid_credentials) { { email: "john@form.com", password: "password" } }

      it "returns a JWT token" do
        post '/api/login', params: valid_credentials
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to have_key('token')
      end
    end

    context "with invalid credentials" do
      let(:invalid_credentials) { { email: "john@form.com", password: "wrongpassword" } }

      it "returns an error" do
        post '/api/login', params: invalid_credentials
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)['error']).to eq('Invalid email or password')
      end
    end
  end
  describe "GET /api/validate" do
    let(:user) { create(:user) }
    let(:token) { JWT.encode({ user_id: user.id }, 'your_secret_key') }

    context "with a valid token" do
      it "returns a success message" do
        get '/api/validate', headers: { Authorization: "Bearer #{token}" }
        expect(response).to have_http_status(:ok)
        expect(response.body).to eq('HTTP 200 OK')
      end
    end

    context "with an invalid token" do
      it "returns an error" do
        get '/api/validate', headers: { Authorization: "Bearer invalidtoken" }
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)['error']).to eq('Unauthorized')
      end
    end
  end

  describe "GET /api/refresh" do
    let(:user) { create(:user) }
    let(:token) { JWT.encode({ user_id: user.id }, 'your_secret_key') }

    context "with a valid token" do
      it "returns a new token" do
        get '/api/refresh', headers: { Authorization: "Bearer #{token}" }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to have_key('token')
      end
    end

    context "with an invalid token" do
      it "returns an error" do
        get '/api/refresh', headers: { Authorization: "Bearer invalidtoken" }
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)['error']).to eq('Unauthorized')
      end
    end
  end
end
