require "rails_helper"

feature "User views decrypted message", %{
  As a user
  I want to view my decrypted message
  So I can read what my friend has written to me
} do

  # Acceptance Criteria
  # [] I must be logged in
  # [] I must enter my secret key
  # [] The secret key I enter must match my secret key
  # [] I can only view messages of which I am the recipient.
  # [] When I click on decrypt, I am taken to the decrypted message page
  # [] The message I view is the message that was written to me,
  #    stripped of punctuation, spacing, and capitalization

  before(:each) do
    @user = FactoryGirl.create(:user)
    @user.secret_key_p = 171078169
    @user.secret_key_q = 171079817
    @user.public_key_m = 29268021845215073
    @user.public_key_k = 5339869
    @user.save

    @friend = FactoryGirl.create(:user)
    Friendship.create(user: @user, friend: @friend, confirmed: true)

    message = "This message will be over one-hundred characters
    long if I just keep typing until it reaches at least one-hundred
    characters and then I keep typing a little bit longer."

    visit root_path

    click_on "Sign In"
    fill_in "Login", with: @friend.email
    fill_in "Password", with: @friend.password
    click_on "Log in"

    visit new_message_path

    find("#recipient").select(@user.username)
    fill_in "Body", with: message
    fill_in "Public key m", with: @user.public_key_m
    fill_in "Public key k", with: @user.public_key_k
    click_on "Send"
    click_on "Sign Out"

    visit root_path

    click_on "Sign In"

    fill_in "Login", with: @user.email
    fill_in "Password", with: @user.password
    click_on "Log in"
  end

  scenario "User views her decrypted message" do
    click_on "Mailbox"
    fill_in "Secret key p", with: @user.secret_key_p
    fill_in "Secret key q", with: @user.secret_key_q
    click_on "Decrypt"

    expect(page).to have_content "thismessagewillbeoveronehundredcharacterslong"
  end

  scenario "Non-recipient user cannot view decrypted message" do
    message = Message.find_by(recipient: @user)
    user = FactoryGirl.create(:user)
    click_on "Sign Out"
    click_on "Sign In"

    fill_in "Login", with: user.email
    fill_in "Password", with: user.password
    click_on "Log in"

    visit message_path(message)

    expect(page).not_to have_content "thismessagewillbeoveronehundredcharacters"
  end

end
