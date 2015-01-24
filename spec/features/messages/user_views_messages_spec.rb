require "rails_helper"

feature "User views encrypted messages", %{
  As a user
  I want to show people my encrypted messages
  So that my friend can feel special when they decrypt their message
} do

  # Acceptance Criteria
  # [] I must be logged in
  # [] I can see encrypted messages posted by all of my friends on my posts page
  # [] I can see the name of the recipient
  # [] I can see the date and time the message is posted
  # [] If the recipient is me, I can see the message in my mailbox
  # [] I can see my secret key in my mailbox
  # [] I can decrypt the message in my mailbox
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
  end

  scenario "User views a friend's encrypted message in feed" do
    @user1 = FactoryGirl.create(:user)

    visit root_path

    click_on "Sign In"

    fill_in "Login", with: @user1.email
    fill_in "Password", with: @user1.password
    click_on "Log in"

    Friendship.create(user: @user1, friend: @friend, confirmed: true)

    click_on "Feed"

    expect(page).to have_content "13987979245948945, 6597549169661591,
                                  19501227974711707, 15878093936820780,
                                  17120061003915500, 1674708906257554,
                                  19207038272600258, 5842957003381056,
                                  9179485880262553, 19536289285048631,
                                  2786926719715928, 11025250514274376,
                                  17197200100095568, 29250927161084515,
                                  13819283828387603, 15802654134488562,
                                  21826030828151967, 25410511871589372"
    expect(page).to have_content @user.username
  end

  scenario "User views inverse-friend's encrypted message in feed" do
    @user1 = FactoryGirl.create(:user)

    visit root_path

    click_on "Sign In"

    fill_in "Login", with: @user1.email
    fill_in "Password", with: @user1.password
    click_on "Log in"

    Friendship.create(user: @friend, friend: @user1, confirmed: true)

    click_on "Feed"

    expect(page).to have_content "13987979245948945, 6597549169661591,
                                  19501227974711707, 15878093936820780,
                                  17120061003915500, 1674708906257554,
                                  19207038272600258, 5842957003381056,
                                  9179485880262553, 19536289285048631,
                                  2786926719715928, 11025250514274376,
                                  17197200100095568, 29250927161084515,
                                  13819283828387603, 15802654134488562,
                                  21826030828151967, 25410511871589372"
    expect(page).to have_content @user.username
  end

  scenario "User views her own encrypted message in feed" do
    visit root_path

    click_on "Sign In"

    fill_in "Login", with: @user.email
    fill_in "Password", with: @user.password
    click_on "Log in"

    click_on "Feed"

    expect(page).to have_content "13987979245948945, 6597549169661591,
                                  19501227974711707, 15878093936820780,
                                  17120061003915500, 1674708906257554,
                                  19207038272600258, 5842957003381056,
                                  9179485880262553, 19536289285048631,
                                  2786926719715928, 11025250514274376,
                                  17197200100095568, 29250927161084515,
                                  13819283828387603, 15802654134488562,
                                  21826030828151967, 25410511871589372"
    expect(page).to have_content @user.username
  end

  scenario "User views her own encrypted message in mailbox" do
    visit root_path

    click_on "Sign In"

    fill_in "Login", with: @user.email
    fill_in "Password", with: @user.password
    click_on "Log in"

    click_on "Mailbox"

    expect(page).to have_content @user.secret_key_p
    expect(page).to have_content @user.secret_key_q
    expect(page).to have_content "13987979245948945, 6597549169661591,
                                  19501227974711707, 15878093936820780,
                                  17120061003915500, 1674708906257554,
                                  19207038272600258, 5842957003381056,
                                  9179485880262553, 19536289285048631,
                                  2786926719715928, 11025250514274376,
                                  17197200100095568, 29250927161084515,
                                  13819283828387603, 15802654134488562,
                                  21826030828151967, 25410511871589372"
    expect(page).to have_content @user.username
    expect(page).to have_button "Decrypt"
  end

  scenario "User cannot view friend's encrypted message in mailbox" do
    @user1 = FactoryGirl.create(:user)

    visit root_path

    click_on "Sign In"

    fill_in "Login", with: @user1.email
    fill_in "Password", with: @user1.password
    click_on "Log in"

    Friendship.create(user: @user1, friend: @friend, confirmed: true)

    click_on "Mailbox"

    expect(page).not_to have_content "13987979245948945, 6597549169661591,
    19501227974711707, 15878093936820780, 17120061003915500, 1674708906257554,
    19207038272600258, 5842957003381056, 9179485880262553, 19536289285048631,
    2786926719715928, 11025250514274376, 17197200100095568, 29250927161084515,
    13819283828387603, 15802654134488562, 21826030828151967,
    25410511871589372"
  end

  scenario "User cannot view unconfirmed friend's encrypted message in feed" do
    @user1 = FactoryGirl.create(:user)

    visit root_path

    click_on "Sign In"

    fill_in "Login", with: @user1.email
    fill_in "Password", with: @user1.password
    click_on "Log in"

    Friendship.create(user: @user1, friend: @friend, confirmed: false)

    click_on "Feed"

    expect(page).not_to have_content "13987979245948945, 6597549169661591,
                                      19501227974711707, 15878093936820780,
                                      17120061003915500, 1674708906257554,
                                      19207038272600258, 5842957003381056,
                                      9179485880262553, 19536289285048631,
                                      2786926719715928, 11025250514274376,
                                      17197200100095568, 29250927161084515,
                                      13819283828387603, 15802654134488562,
                                      21826030828151967, 25410511871589372"
    expect(page).not_to have_content @user.username
  end

  scenario "User cannot view non-friend's encrypted message" do
    @user1 = FactoryGirl.create(:user)

    visit root_path

    click_on "Sign In"

    fill_in "Login", with: @user1.email
    fill_in "Password", with: @user1.password
    click_on "Log in"

    click_on "Feed"

    expect(page).not_to have_content "13987979245948945, 6597549169661591,
                                      19501227974711707, 15878093936820780,
                                      17120061003915500, 1674708906257554,
                                      19207038272600258, 5842957003381056,
                                      9179485880262553, 19536289285048631,
                                      2786926719715928, 11025250514274376,
                                      17197200100095568, 29250927161084515,
                                      13819283828387603, 15802654134488562,
                                      21826030828151967, 25410511871589372"

    expect(page).not_to have_content @user.username
  end
end
