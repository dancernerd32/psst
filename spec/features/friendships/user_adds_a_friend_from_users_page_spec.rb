require "rails_helper"

feature "User adds a friend", %{
  As a user
  I want to add a friend
  So that I can see their posts and send secret messages
} do

  # Acceptance Criteria
  # [x] I must be logged in
  # [x] I can add a friend by clicking a button next to their username
  # [x] When I add a friend I receive a message telling me I've done so
  #    successfully
  # *[] When I add a friend, my friend receives a notification in their mailbox
  # *[] I cannot send my friend a message until he/she confirms the friendship
  # *[] I cannot see my friend's public key until he or she confirms the
  #    friendship

  context "authenticated user" do
    before(:each) do
      @user1 = FactoryGirl.create(:user)

      visit root_path

      click_on "Sign In"

      fill_in "Login", with: @user1.email
      fill_in "Password", with: @user1.password
      click_on "Log in"

    end

    scenario "user adds a new friend from users list page" do

      user2 = FactoryGirl.create(:user)

      visit users_path

      expect(page).to have_content user2.username
      click_on "Add #{user2.username} as a friend"

      expect(page).to have_content "You have successfully added #{
      user2.username} as a friend.  We'll let you know when they confirm your
      friendship"

      visit users_path

      expect(page).to have_content user2.username
      expect(page).to_not have_content "Add #{user2.username} as a friend"
    end

    scenario "User adds friend from user profile page" do

      user2 = FactoryGirl.create(:user)

      visit user_path(user2)

      click_on "Add friend"

      expect(page).to have_content "You have successfully added #{
      user2.username} as a friend.  We'll let you know when they confirm your
      friendship"
    end

    scenario "User cannot add a friend who has already been added" do

      user2 = FactoryGirl.create(:user)
      user3 = FactoryGirl.create(:user)

      visit users_path

      click_on "Add #{user2.username} as a friend"

      visit users_path

      expect(page).to have_content user2.username
      expect(page).not_to have_content "Add #{user2.username} as a friend"
      expect(page).to have_content "Add #{user3.username} as a friend"
    end
  end

  scenario "Unauthenticated user tries to add a friend" do

    FactoryGirl.create(:user)

    visit users_path

    expect(page).to have_content "You need to sign in or sign up"
  end

end
