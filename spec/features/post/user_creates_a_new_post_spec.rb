require "rails_helper"

feature "User creates a new public post", %{
  As a user
  I want to create a public post
  So that I can tell people something I find interesting
} do

  # Acceptance Criteria
  # [] I must be logged in
  # [] I must enter a body
  # [] My post cannot be longer than 255 characters
  # [] When I create a post, I can see it on my home page

  context "authenticated user" do
    before(:each) do
      @user1 = FactoryGirl.create(:user)

      visit root_path

      click_on "Sign In"

      fill_in "Login", with: @user1.email
      fill_in "Password", with: @user1.password
      click_on "Log in"

    end
    scenario "User creates a post" do

      visit posts_path

      fill_in "Body", with: "Text"
      click_on "Submit"

      expect(page).to have_content "Text"

    end

    scenario "User provides invalid post"

  end

  scenario "Unauthenticated user tries to create a post"

end
