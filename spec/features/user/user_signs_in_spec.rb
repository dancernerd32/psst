require "rails_helper"

feature "user signs in", %{
  As a signed up user
  I want to sign in
  So that I can regain access to my account
} do
  scenario "specify valid credentials - email" do
    user = FactoryGirl.create(:user)

    visit new_user_session_path

    fill_in "Login", with: user.email
    fill_in "Password", with: user.password

    click_button "Log in"

    expect(page).to have_content("Signed in successfully")
    expect(page).to have_content("Sign Out")
  end

  scenario "specify valid credentials - username" do
    user = FactoryGirl.create(:user)

    visit new_user_session_path

    fill_in "Login", with: user.username
    fill_in "Password", with: user.password

    click_button "Log in"

    expect(page).to have_content("Signed in successfully")
    expect(page).to have_content("Sign Out")
  end

  scenario "specify invalid credentials" do
    visit new_user_session_path

    click_button "Log in"
    expect(page).to have_content("Invalid login or password")
    expect(page).to_not have_content("Sign Out")
  end
end
