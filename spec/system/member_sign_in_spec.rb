require 'rails_helper'

RSpec.describe "Member sign in", type: :system do
  before do
    driven_by(:rack_test)
  end

  let!(:member) { create(:member) }

  it "allows user to sign in and shows current_user email" do
    visit new_member_session_path

    fill_in "Email", with: member.email
    fill_in "Password", with: member.password
    click_button "Sign in"

    expect(page).to have_text("Signed in successfully")
    expect(page).to have_text("#{member.email}")
  end
end
