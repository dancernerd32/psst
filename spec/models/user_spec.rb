require "rails_helper"

RSpec.describe User, :type => :model do
  let(:blank_values) { [nil, ""] }
  it { should have_valid(:username).when("Any 1 .!@#$%^&*}text") }
  it { should_not have_valid(:username).when(*blank_values) }
  it { should have_valid(:first_name).when("Any 1 .!@#$%^&*}text") }
  it { should_not have_valid(:first_name).when(*blank_values) }
  it { should have_valid(:last_name).when("Any 1 .!@#$%^&*}text") }
  it { should_not have_valid(:last_name).when(*blank_values) }
end
