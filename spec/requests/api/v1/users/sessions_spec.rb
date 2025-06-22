# spec/requests/api/v1/users/sessions_spec.rb

require 'rails_helper'

RSpec.describe "Api::V1::Users::Sessions", type: :request do
  let!(:user) do
    User.create!(
        first_name: "John",
        last_name: "Doe",
        username: "johndoe",
        email: "john@example.com",
        phone: "1234567890",
        password: "password123",
        password_confirmation: "password123",
        role: :student
    )
  end

  before do
    # Tell Devise to use :user mapping in this request spec
    @request.env["devise.mapping"] = Devise.mappings[:user] if defined?(@request)
  end

  describe "POST /api/v1/users/login" do
    let(:login_url) { api_v1_user_session_path }

    context "with valid credentials" do
      let(:valid_params) do
        {
            user: {
                login: user.email,
                password: "password123"
            }
        }
      end

      it "logs in the user and returns JWT token" do
        post login_url, params: valid_params, as: :json

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)

        expect(json["message"]).to eq("Signed in successfully.")
        expect(json["token"]).to be_present
        expect(json["user"]["email"]).to eq(user.email)
      end
    end

    context "with invalid credentials" do
      let(:invalid_params) do
        {
            user: {
                login: user.email,
                password: "wrongpassword"
            }
        }
      end

      it "returns unauthorized status with error" do
        post login_url, params: invalid_params, as: :json

        expect(response).to have_http_status(:unauthorized)
        json = JSON.parse(response.body)
        expect(json["errors"]).to include("Invalid login or password")
      end
    end
  end

  describe "DELETE /api/v1/users/logout" do
    let(:logout_url) { destroy_api_v1_user_session_path }

    context "with valid JWT token" do
      it "logs out the user and revokes token" do
        token = JWT.encode(
            { sub: user.id, exp: 1.day.from_now.to_i, jti: SecureRandom.uuid },
            Rails.application.credentials.jwt.secret,
            Rails.application.credentials.jwt.algorithm || 'HS256'
        )

        delete logout_url, headers: { "Authorization" => "Bearer #{token}" }, as: :json

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json["message"]).to eq("Logged out successfully.")
      end
    end

    context "without token" do
      it "returns unauthorized error" do
        delete logout_url, as: :json

        expect(response).to have_http_status(:unauthorized)
        json = JSON.parse(response.body)
        expect(json["error"]).to eq("Authorization token missing")
      end
    end

    context "with invalid token" do
      it "returns unauthorized error" do
        delete logout_url, headers: { "Authorization" => "Bearer invalidtoken" }, as: :json

        expect(response).to have_http_status(:unauthorized)
        json = JSON.parse(response.body)
        expect(json["error"]).to match(/Invalid token/)
      end
    end
  end
end
