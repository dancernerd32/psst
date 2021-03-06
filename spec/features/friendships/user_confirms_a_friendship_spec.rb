require "rails_helper"

feature "User confirms friendship", %{
  As a user
  I want to confirm a friendship
  So that I am friends with another user
} do

  # Acceptance Criteria
  # [x] I must be logged in
  # [] Someone must have added me as a friend
  # *[] When I visit my mailbox I can see a message, letting me know someone has
  #    added me as a friend
  # [x] When I confirm a friendship, I am given a success message, letting me
  #    that we are now friends
  # *[] When I confirm a friendship, my friend receives a message in their
  #    mailbox, letting them know I have confirmed
  # *[] I can send messages to confirmed friends
  # *[] Confirmed friends can send messages to me

  context "Authenticated user" do
    before(:each) do
      @user1 = FactoryGirl.create(:user)

      visit root_path

      click_on "Sign In"

      fill_in "Login", with: @user1.email
      fill_in "Password", with: @user1.password
      click_on "Log in"
    end
    scenario "User confirms a friendship" do

      user2 = FactoryGirl.create(:user)

      Friendship.create(user: user2, friend: @user1)

      visit user_friendships_path(@user1)

      click_on "Confirm friendship"

      expect(page).to have_content "You and #{ user2.username } are now friends"
      click_on "Friends"

      expect(page).to have_content(user2.username)

    end
    scenario "User cannot confirm a friendship another user's friendship" do
      users = FactoryGirl.create_list(:user, 2)
      Friendship.create(user: users[0], friend: users[1], confirmed: false)

      visit user_friendships_path(users[0])

      expect(page).to have_content "You are not authorized to view this page"
      expect(page).not_to have_content "Confirm"
    end
  end

  scenario "Unauthenticated user cannot confirm a friendship" do
    @user1 = FactoryGirl.create(:user)
    visit user_friendships_path(@user1)

    expect(page).to have_content "Log in"

  end
end
