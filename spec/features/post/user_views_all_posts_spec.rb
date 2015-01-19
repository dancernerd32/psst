require "rails_helper"

feature "User views all posts", %{
  As a user
  I want to view posts
  So that I can find out what my friends are saying
} do

  # Acceptance Criteria
  # [x] I must be logged in to view posts
  # [x] I can only see my friends' and my own posts
  # [x] I can see the username of the post creator
  # [x] I can see the date of creation
  # [x] I can see the time of creation
  # [x] I can see the body of the post
  # [x] The posts are ordered from most recent to oldest

  context "Authenticated user" do
    before(:each) do
      @user1 = FactoryGirl.create(:user)

      visit root_path

      click_on "Sign In"

      fill_in "Login", with: @user1.email
      fill_in "Password", with: @user1.password
      click_on "Log in"
    end

    scenario "User sees her inverse-friend's post" do
      user = FactoryGirl.create(:user)
      Friendship.create(user: user, friend: @user1, confirmed: true)

      post = FactoryGirl.create(:post, user: user)

      visit posts_path

      expect(page).to have_content post.body

    end

    scenario "User sees her friend's post" do
      user = FactoryGirl.create(:user)
      Friendship.create(user: @user1, friend: user, confirmed: true)

      post = FactoryGirl.create(:post, user: user)

      visit posts_path

      expect(page).to have_content post.body
    end

    scenario "User sees her own post" do
      post = FactoryGirl.create(:post, user: @user1)

      visit posts_path

      expect(page).to have_content post.body
    end

    scenario "User does not see the post of a non-friend" do
      post = FactoryGirl.create(:post)

      visit posts_path

      expect(page).not_to have_content post.body

    end
    scenario "User does not see the post of a pending friend" do
      user = FactoryGirl.create(:user)
      Friendship.create(user: user, friend: @user1, confirmed: false)

      post = FactoryGirl.create(:post, user: user)

      visit posts_path

      expect(page).not_to have_content post.body
    end

    scenario "User does not see the post of a requested friend" do
      user = FactoryGirl.create(:user)
      Friendship.create(user: @user1, friend: user, confirmed: false)

      post = FactoryGirl.create(:post, user: user)

      visit posts_path

      expect(page).not_to have_content post.body
    end

    scenario "User views multiple posts" do

      users = FactoryGirl.create_list(:user, 2)
      Friendship.create(user: @user1, friend: users[0], confirmed: true)
      Friendship.create(user: users[1], friend: @user1, confirmed: true)

      post1 = FactoryGirl.create(
              :post,
              user: users[0],
              created_at: "2015-01-13 16:29:07 -0500"
              )
      post2 = FactoryGirl.create(:post, user: users[1])
      post3 = FactoryGirl.create(:post, user: @user1)

      visit posts_path

      expect(page).to have_content post1.body
      expect(page).to have_content post2.body
      expect(page).to have_content post3.body
      expect(page).to have_content post1.user.username
      expect(post3.body).to appear_before(post2.body)
      expect(page).to have_content "January 13, 2015 at 4:29pm"

    end

  end

  scenario "Unauthenticated user tries to view posts" do

    visit posts_path

    expect(page).to have_content "Log in"
  end

end
