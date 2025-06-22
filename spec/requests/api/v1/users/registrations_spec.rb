# spec/requests/api/v1/users/registrations_spec.rb

require 'rails_helper'

RSpec.describe "Api::V1::Users::Registrations", type: :request do
  describe "POST /api/v1/users" do
    let(:valid_attributes) do
      {
          user: {
              first_name: "John",
              last_name: "Doe",
              username: "johndoe",
              email: "john@example.com",
              phone: "1234567890",
              password: "password123",
              password_confirmation: "password123"
          }
      }
    end

    let(:invalid_attributes) do
      {
          user: {
              email: "",
              phone: "123",
              password: "pass",
              password_confirmation: "mismatch"
          }
      }
    end

    context "with valid params" do
      it "creates a new user and returns token" do
        post api_v1_user_registration_path, params: valid_attributes, as: :json

        expect(response).to have_http_status(:created)
        json = JSON.parse(response.body)

        expect(json['status']['code']).to eq(200)
        expect(json['status']['message']).to eq('Signed up successfully.')
        expect(json['data']['email']).to eq('john@example.com')
        expect(json['token']).to be_present
      end
    end

    context "with invalid params" do
      it 'does not create user and returns errors' do
        post api_v1_user_registration_path, params: invalid_attributes, as: :json

        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)
        expect(json['errors']).to include("Email can't be blank", "First name can't be blank", "Last name can't be blank")
      end
    end
  end
end
