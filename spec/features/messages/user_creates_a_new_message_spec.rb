require "rails_helper"
require "encryption_helper"

feature "User creates a new message", %{
  As a user
  I want to create a message
  So that I can send a message to my friend
} do

  # Acceptance Criteria
  # [] I must be logged in
  # [] I must specify a receiver
  # [] The message receiver must be a confirmed friend or an inverse friend
  # [] I can choose a receiver from a drop-down menu
  # [] I must provide a message with at least 100 characters
  # [] I must specify a public key m and a public key k
  # [] The public keys specified must match the message receiver's public keys
  # [] When I click send, I receive an alert that my message is not secure, and
  #    the option to cancel or continue
  # [] When I send a message, I am given a success message
  # [] If I am unable to send a message, I can see a list of errors
  # [] My encrypted message appears on my posts feed
  # [] My encrypted message appears on my friends' posts feeds
  # [] My encrypted message appears on the receiver's profile page
  before(:each) do
    visit new_user_registration_path

    fill_in "First name", with: "John"
    fill_in "Last name", with: "Example"
    fill_in "Email", with: "john@example.com"
    fill_in "Username", with: "john"
    fill_in "Password", with: "password"
    fill_in "Password confirmation", with: "password"

    click_on "Sign up"
    click_on "Sign Out"
  end

  before(:each) do
    @user = FactoryGirl.create(:user)
    @user.secret_key_p = 171078169
    @user.secret_key_q = 171079817
    @user.public_key_m = 29268021845215073
    @user.public_key_k = 5339869
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
      expect(page).to have_content ["3018192923152929", "1117153319222212",
        "1525321528252415",
        "1831241428151413",
        "1811281113301528",
        "2922252417191619",
        "2031293021151526",
        "3035261924173124",
        "3019221930281511",
        "1318152911302215",
        "1129302524151831",
        "2414281514131811",
        "2811133015282911",
        "2414301815241921",
        "1515263035261924",
        "1711221930302215",
        "1219302225241715",
        "28"]

    end
    scenario "user sends a message to an inverse friend"
    scenario "user doesn't specify a friend"
    scenario "user enters the wrong public key"
    scenario "user cannot send message to a non-friend/inverse-friend" do
      visit new_message_path

      expect(page).not_to have_select("message[recipient_id]",
                                      options: [@user.username])
    end
    scenario "user cannot send a message to an unconfirmed friend or
    inverse-friend"
    scenario "user cannot send a message to herself"
  end
  scenario "unauthenticated user"
end
