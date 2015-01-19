require "rails_helper"

RSpec.describe Post, type: :model do
  let(:blank_values) { [nil, ""] }
  it { should have_valid(:body).when("Any 1 .!@#$%^&*}text") }
  it do
    should_not have_valid(:body).when(
      *blank_values,
       "This post is going to be longer than 255 characters
       this post is going to be longer than 255 characters
       this post is going to be longer than 255 characters
       this post is going to be longer than 255 characters
       this post is going to be longer than 255 characters
       this post is going to be longer than 255 characters"
    )
  end

  it { should belong_to :user }
end
