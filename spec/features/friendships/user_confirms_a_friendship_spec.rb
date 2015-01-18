require "rails_helper"

feature "User confirms friendship", %{
  As a user
  I want to confirm a friendship
  So that I am friends with another user
} do

  # Acceptance Criteria
  # [] I must be logged in
  # [] Someone must have added me as a friend
  # [] When I visit my mailbox I can see a message, letting me know someone has
  #    added me as a friend
  # [] When I confirm a friendship, I am given a success message, letting me
  #    that we are now friends
  # [] When I confirm a friendship, my friend receives a message in their
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

      friend_request = Friendship.create(user: user2, friend: @user1)

      visit user_friendships_path(@user1)

      click_on "Confirm friendship"

      expect(page).to have_content "You and #{user2.username} are now friends."

    end
  end
end
