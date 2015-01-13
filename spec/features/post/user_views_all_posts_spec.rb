require "rails_helper"

feature "User views all posts", %{
  As a user
  I want to view messages
  So that I can find out what my friends are saying
} do

  # Acceptance Criteria
  # [] I must be logged in to view posts
  # [] I can see the username of the post creator
  # [] I can see the date of creation
  # [] I can see the time of creation
  # [] I can see the body of the post
  # [] The posts are ordered from most recent to oldest
  # [] I can see at most 20 posts on a page
  # [] If no posts exist the page, the site doesn't break

  context "Authenticated user" do
    before(:each) do
      @user1 = FactoryGirl.create(:user)

      visit root_path

      click_on "Sign In"

      fill_in "Login", with: @user1.email
      fill_in "Password", with: @user1.password
      click_on "Log in"
    end

    scenario "User views multiple posts" do
      post1 = FactoryGirl.create(:post, created_at: "2015-01-13 19:50:52 UTC")
      visit posts_path
      save_and_open_page
      post2 = FactoryGirl.create(:post)
      post3 = FactoryGirl.create(:post, user: @user1)

      visit posts_path
      save_and_open_page

      expect(page).to have_content post1.body
      expect(page).to have_content post2.body
      expect(page).to have_content post3.body
      expect(page).to have_content post1.user.username
      expect(post3.body).to appear_before(post2.body)
      expect(page).to have_content "January 1, 2015 at 7:50pm"

    end

  end

  scenario "Unauthenticated user tries to view posts"
end
