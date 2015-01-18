require "rails_helper"

feature "User removes a friend", %{
  As a user
  I want to remove a friend
  So she can no longer see my posts or send messages to me
} do

  # Acceptance Criteria
  # [] I must be logged in
  # [] I must have a confirmed friendship with the friend I wish to remove
  # [] I can only remove my own friendships and inverse friendships
  # [] When I successfully remove I friend I can see a success message
  # [] When I remove a friend their posts no longer show up on my home page
  # [] When I remove a friend, my posts no longer show up on their home page
  # *[] When I remove a friend, we can no longer send messages to each other
  # *[] When I remove a friend, we can no longer view each other's public keys

  context "authenticated user" do
    before(:each) do
      @user1 = FactoryGirl.create(:user)

      visit root_path

      click_on "Sign In"

      fill_in "Login", with: @user1.email
      fill_in "Password", with: @user1.password
      click_on "Log in"
    end

    scenario "User removes a friend" do
      friend = FactoryGirl.create(:user)
      Friendship.create(user: @user1, friend: friend, confirmed: true)

      visit user_friendships_path(@user1)

      click_on "Remove #{friend.username} from friends"

      expect(page).to have_content "#{friend.username} was successfully removed"
      expect(page).not_to have_content friend.first_name
    end

    scenario "User removes an inverse friend" do
      friend = FactoryGirl.create(:user)
      Friendship.create(friend: @user1, user: friend, confirmed: true)

      visit user_friendships_path(@user1)

      click_on "Remove #{friend.username} from friends"

      expect(page).to have_content "#{friend.username} was successfully removed"
      expect(page).not_to have_content friend.first_name
    end
    scenario "User tries to remove a pending friend" do
      friend = FactoryGirl.create(:user)
      Friendship.create(user: @user1, friend: friend, confirmed: false)

      visit user_friendships_path(@user1)

      expect(page).not_to have_content "Remove #{friend.username} from friends"
    end

    scenario "User tries to remove a friend request" do
      friend = FactoryGirl.create(:user, username: "friend")
      Friendship.create(friend: @user1, user: friend, confirmed: false)

      visit user_friendships_path(@user1)

      expect(page).not_to have_content "Remove #{friend.username} from friends"
    end
    scenario "User has no option to remove a friendship with a non-friend user"
    do
      user1 = FactoryGirl.create(:user)
      user2 = FactoryGirl.create(:user)
      Friendship.create(user: user1, friend: user2, confirmed: true)

      visit user_friendships_path(user1)

      expect(page).to have_content "You are not authorized to view this page"
      expect(page).not_to have_content "Remove #{user2.username} from friends"
    end
  end
end
