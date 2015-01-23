require "rails_helper"
require "encryption_helper"

feature "User creates a new message", %{
  As a user
  I want to create a message
  So that I can send a message to my friend
} do

  # Acceptance Criteria
  # [] I must be logged in
  # [x] I must specify a receiver
  # [x] The message receiver must be a confirmed friend or an inverse friend
  # [x] I can choose a receiver from a drop-down menu
  # [x] I must provide a message with at least 100 characters
  # [x] I must specify a public key m and a public key k
  # [x] The public keys specified must match the message receiver's public keys
  # [] When I click send, I receive an alert that my message is not secure, and
  #    the option to cancel or continue
  # [x] When I send a message, I am given a success message
  # [x] If I am unable to send a message, I can see a list of errors
  # [x] My encrypted message appears on my posts feed
  # [] My encrypted message appears on my friends' posts feeds
  # [] My encrypted message appears on the receiver's profile page

  before(:each) do
    @user = FactoryGirl.create(:user)
    @user.secret_key_p = 171078169
    @user.secret_key_q = 171079817
    @user.public_key_m = 29268021845215073
    @user.public_key_k = 5339869
    @user.save
  end

  context "authenticated user" do
    before(:each) do
      @user1 = FactoryGirl.create(:user)

      visit root_path

      click_on "Sign In"

      fill_in "Login", with: @user1.email
      fill_in "Password", with: @user1.password
      click_on "Log in"
    end

    scenario "user sends a message to a friend" do

      message = "This message will be over one-hundred characters
      long if I just keep typing until it reaches at least one-hundred
      characters and then I keep typing a little bit longer."

      Friendship.create(user: @user1, friend: @user, confirmed: true)

      visit new_message_path

      find("#recipient").select(@user.username)
      fill_in "Body", with: message
      fill_in "Public key m", with: @user.public_key_m
      fill_in "Public key k", with: @user.public_key_k
      click_on "Send"
      # click_on "Continue"

      expect(page).to have_content "Your message has been sent"
      expect(page).to have_content "13987979245948945, 6597549169661591,
      19501227974711707, 15878093936820780, 17120061003915500, 1674708906257554,
      19207038272600258, 5842957003381056, 9179485880262553, 19536289285048631,
      2786926719715928, 11025250514274376, 17197200100095568, 29250927161084515,
      13819283828387603, 15802654134488562, 21826030828151967,
      25410511871589372"
    end

    scenario "user sends a message to an inverse friend" do
      message = "This message will be over one-hundred characters
      long if I just keep typing until it reaches at least one-hundred
      characters and then I keep typing a little bit longer."

      Friendship.create(user: @user, friend: @user1, confirmed: true)

      visit new_message_path

      find("#recipient").select(@user.username)
      fill_in "Body", with: message
      fill_in "Public key m", with: @user.public_key_m
      fill_in "Public key k", with: @user.public_key_k
      click_on "Send"

      expect(page).to have_content "Your message has been sent"
      expect(page).to have_content "13987979245948945, 6597549169661591,
      19501227974711707, 15878093936820780, 17120061003915500, 1674708906257554,
      19207038272600258, 5842957003381056, 9179485880262553, 19536289285048631,
      2786926719715928, 11025250514274376, 17197200100095568, 29250927161084515,
      13819283828387603, 15802654134488562, 21826030828151967,
      25410511871589372"
    end

    scenario "user doesn't input body" do

      Friendship.create(user: @user, friend: @user1, confirmed: true)

      visit new_message_path

      fill_in "Public key m", with: @user.public_key_m
      fill_in "Public key k", with: @user.public_key_k
      click_on "Send"

      expect(page).to have_content "Body can't be blank"
    end

    scenario "user enters the wrong public key" do
      message = "This message will be over one-hundred characters
      long if I just keep typing until it reaches at least one-hundred
      characters and then I keep typing a little bit longer."

      Friendship.create(user: @user, friend: @user1, confirmed: true)

      visit new_message_path

      find("#recipient").select(@user.username)
      fill_in "Body", with: message
      fill_in "Public key m", with: @user.public_key_k
      fill_in "Public key k", with: @user.public_key_k
      click_on "Send"

      expect(page).to have_content "Public keys must match recipient's public keys"
    end

    scenario "user cannot send message to a non-friend/inverse-friend" do
      visit new_message_path

      expect(page).not_to have_select("message[recipient_id]",
                                      options: [@user.username])
    end

    scenario "user cannot send a message to an unconfirmed friend" do
      Friendship.create(user: @user1, friend: @user)
      visit new_message_path

      expect(page).not_to have_select("message[recipient_id]",
      options: [@user.username])
    end

    scenario "user cannot send a message to herself" do
      Friendship.create(user: @user, friend: @user1, confirmed: true)
      visit new_message_path

      expect(page).not_to have_select("message[recipient_id]",
      options: [@user1.username])
    end
  end

  scenario "unauthenticated user" do
    visit new_message_path

    expect(page).to have_content "Log in"
  end
end
