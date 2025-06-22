require 'rails_helper'

RSpec.describe User, type: :model do
  subject do
    described_class.new(
        first_name: "John",
        last_name: "Doe",
        username: "johndoe",
        email: "john@example.com",
        phone: "1234567890",
        password: "password123"
    )
  end

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is not valid without a first_name' do
      subject.first_name = nil
      expect(subject).to_not be_valid
      expect(subject.errors[:first_name]).to include("can't be blank")
    end

    it 'is not valid without a last_name' do
      subject.last_name = nil
      expect(subject).to_not be_valid
      expect(subject.errors[:last_name]).to include("can't be blank")
    end

    it 'is not valid without a username' do
      subject.username = nil
      expect(subject).to_not be_valid
      expect(subject.errors[:username]).to include("can't be blank")
    end

    it 'is not valid without an email' do
      subject.email = nil
      expect(subject).to_not be_valid
      expect(subject.errors[:email]).to include("can't be blank")
    end

    it 'is not valid with invalid email format' do
      subject.email = "invalid_email"
      expect(subject).to_not be_valid
      expect(subject.errors[:email]).to include("is invalid")
    end

    it 'is not valid without a phone number' do
      subject.phone = nil
      expect(subject).to_not be_valid
      expect(subject.errors[:phone]).to include("can't be blank")
    end

    it 'is not valid with phone number not exactly 10 digits' do
      subject.phone = "12345"
      expect(subject).to_not be_valid
      expect(subject.errors[:phone]).to include("must be 10 digits")
    end

    it 'is not valid without a password on create' do
      subject.password = nil
      expect(subject).to_not be_valid
      expect(subject.errors[:password]).to include("can't be blank")
    end

    it 'has the correct enum roles' do
      expect(User.roles.keys).to contain_exactly('member', 'student', 'author', 'teacher', 'admin')
    end
  end
end
