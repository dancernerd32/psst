require "rails_helper"

feature "User views her friendships", %{
  As a user
  I want to view my friends
  So that I know who I am friends with
} do

  # Acceptance Criteria
  # [] I must be logged in
  # [] I can click on the friends link in the nav bar to be taken to my friends
  #    page
  # [] I can see all of my confirmed friends and inverse friends
  # [] I can see all of my friend requests
  # [] I can see all of my pending friendships
  # [] If I am not logged in, I am taken to the login page

  context "Authenticated user" do
    before(:each) do
      @user1 = FactoryGirl.create(:user)

      visit root_path

      click_on "Sign In"

      fill_in "Login", with: @user1.email
      fill_in "Password", with: @user1.password
      click_on "Log in"
    end

    scenario "User views friends, pending friendships, and friend requests" do
      user2 = FactoryGirl.create(:user)
      user3 = FactoryGirl.create(:user)
      user4 = FactoryGirl.create(:user)
      user5 = FactoryGirl.create(:user)
      user6 = FactoryGirl.create(:user)

      Friendship.create(user: user2, friend: @user1, confirmed: true)
      Friendship.create(user: @user1, friend: user3, confirmed: true)
      Friendship.create(user: user4, friend: @user1, confirmed: false)
      Friendship.create(user: @user1, friend: user5, confirmed: false)
      Friendship.create(user: user2, friend: user6, confirmed: true)

      visit user_friendships_path(@user1)

      expect(page).to have_content user2.username
      expect(page).to have_content user3.username
      expect(page).to have_content user4.username
      expect(page).to have_content user5.username
      expect(page).not_to have_content user6.username

    end

    scenario "User has no friends, pending friendships, or friend requests" do
      user2 = FactoryGirl.create(:user)
      user3 = FactoryGirl.create(:user)
      user4 = FactoryGirl.create(:user)
      user5 = FactoryGirl.create(:user)
      user6 = FactoryGirl.create(:user)

      Friendship.create(user: user2, friend: user6, confirmed: true)

      visit user_friendships_path(@user1)
      save_and_open_page

      expect(page).not_to have_content user6.username
      expect(page).to have_content "You have no friends on Psst! at this time"
      expect(page).to have_content "You have no friend requests at this time"
      expect(page).to have_content "You have no pending friends at this time"
    end


  end

  scenario "unauthenticated user tries to view friends" do
    user = FactoryGirl.create(:user)

    visit user_friendships_path(user)

    expect(page).to have_content "Log in"
  end

end
