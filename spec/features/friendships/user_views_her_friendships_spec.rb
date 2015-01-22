require "rails_helper"

feature "User views her friendships", %{
  As a user
  I want to view my friends
  So that I know who I am friends with
} do

  # Acceptance Criteria
  # [x] I must be logged in
  # [x] I can only view my own friends
  # [x] I can click on the friends link in the nav bar to be taken to my friends
  #    page
  # [x] I can see all of my confirmed friends and confirmed inverse friends
  # [x] I can see all of my friend requests
  # [x] I can see all of my pending friendships
  # [x] If I am not logged in, I am taken to the login page

  context "Authenticated user" do
    before(:each) do
      @user1 = FactoryGirl.create(:user)

      visit root_path

      click_on "Sign In"

      fill_in "Login", with: @user1.email
      fill_in "Password", with: @user1.password
      click_on "Log in"
    end
    scenario "User views friends" do
      user = FactoryGirl.create(:user)

      Friendship.create(user: @user1, friend: user, confirmed: true)

      click_on "Friends"
      expect(page).to have_content user.username
    end

    scenario "User views inverse friends" do
      user = FactoryGirl.create(:user)

      Friendship.create(user: user, friend: @user1, confirmed: true)

      click_on "Friends"
      expect(page).to have_content user.username
    end

    scenario "User views pending friendships" do
      user = FactoryGirl.create(:user)

      Friendship.create(user: @user1, friend: user, confirmed: false)

      click_on "Friends"
      expect(page).to have_content user.username
    end

    scenario "User views friend requests" do
      user = FactoryGirl.create(:user)

      Friendship.create(user: user, friend: @user1, confirmed: false)

      click_on "Friends"
      expect(page).to have_content user.username
    end

    scenario "User views friends, pending friendships, and friend requests" do
      users = FactoryGirl.create_list(:user, 4)

      Friendship.create(user: users[0], friend: @user1, confirmed: true)
      Friendship.create(user: @user1, friend: users[1], confirmed: true)
      Friendship.create(user: users[2], friend: @user1, confirmed: false)
      Friendship.create(user: @user1, friend: users[3], confirmed: false)

      click_on "Friends"

      expect(page).to have_content users[0].username
      expect(page).to have_content users[1].username
      expect(page).to have_content users[2].username
      expect(page).to have_content users[3].username
    end

    scenario "User has no friends, pending friendships, or friend requests" do
      FactoryGirl.create_list(:user, 5)

      click_on "Friends"

      expect(page).to have_content "You have no friends on Psst! at this time"
      expect(page).to have_content "You have no friend requests at this time"
      expect(page).to have_content "You have no pending friends at this time"
    end

    scenario "User sees only her own friends on her friends page" do
      user1 = FactoryGirl.create(:user)
      user2 = FactoryGirl.create(:user)
      Friendship.create(user: user1, friend: user2, confirmed: true)

      click_on "Friends"

      expect(page).to have_content "You have no friends on Psst! at this time"
      expect(page).to have_content "You have no friend requests at this time"
      expect(page).to have_content "You have no pending friends at this time"
      expect(page).not_to have_content user1.username
      expect(page).not_to have_content user2.username
    end

    scenario "User cannot view another user's friends" do
      user1 = FactoryGirl.create(:user)
      user2 = FactoryGirl.create(:user)
      Friendship.create(user: user1, friend: user2, confirmed: true)

      visit user_friendships_path(user1)

      expect(page).to have_content "You are not authorized to view this page"
      expect(page).not_to have_content user2.username
    end
  end

  scenario "unauthenticated user tries to view friends" do
    user = FactoryGirl.create(:user)

    visit user_friendships_path(user)

    expect(page).to have_content "Log in"
  end
end
