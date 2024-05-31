require 'rails_helper'

RSpec.describe "Auth", type: :request do
    include FactoryBot::Syntax::Methods
    describe "POST /auth/register" do
    context "with valid parameters" do
      let(:valid_attributes) { { name: "John Doe", email: "john@form.com", password: "password", password_confirmation: "password" } }

      it "creates a new user" do
        expect {
          post '/auth/register', params: valid_attributes
        }.to change(User, :count).by(1)
      end

      it "returns a success message" do
        post '/auth/register', params: valid_attributes
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)['message']).to eq('User created successfully')
      end
    end

    context "with invalid parameters" do
      let(:invalid_attributes) { { name: "", email: "john@form.com", password: "password", password_confirmation: "password" } }

      it "does not create a new user" do
        expect {
          post '/auth/register', params: invalid_attributes
        }.to change(User, :count).by(0)
      end

      it "returns error messages" do
        post '/auth/register', params: invalid_attributes
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['errors']).to include("Name can't be blank")
      end
    end
  end

  describe "POST /auth/login" do
    let!(:user) { create(:user, email: "john@form.com", password: "password") }

    context "with valid credentials" do
      let(:valid_credentials) { { email: "john@form.com", password: "password" } }

      it "returns a JWT token" do
        post '/auth/login', params: valid_credentials
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to have_key('token')
      end
    end

    context "with invalid credentials" do
      let(:invalid_credentials) { { email: "john@form.com", password: "wrongpassword" } }

      it "returns an error" do
        post '/auth/login', params: invalid_credentials
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)['error']).to eq('Invalid email or password')
      end
    end
  end
  describe "GET /auth/validate_token" do
    let(:user) { create(:user) }
    let(:token) { JWT.encode({ user_id: user.id }, 'your_secret_key') }

    context "with a valid token" do
      it "returns a success message" do
        get '/auth/validate_token', headers: { Authorization: "Bearer #{token}" }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['message']).to eq('Token is valid')
      end
    end

    context "with an invalid token" do
      it "returns an error" do
        get '/auth/validate_token', headers: { Authorization: "Bearer invalidtoken" }
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)['error']).to eq('Unauthorized')
      end
    end
  end

  describe "GET /auth/refresh_token" do
    let(:user) { create(:user) }
    let(:token) { JWT.encode({ user_id: user.id }, 'your_secret_key') }

    context "with a valid token" do
      it "returns a new token" do
        get '/auth/refresh_token', headers: { Authorization: "Bearer #{token}" }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to have_key('token')
      end
    end

    context "with an invalid token" do
      it "returns an error" do
        get '/auth/refresh_token', headers: { Authorization: "Bearer invalidtoken" }
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)['error']).to eq('Unauthorized')
      end
    end
  end
end
