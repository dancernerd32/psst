require "rails_helper"

feature "User creates a new message", %{
  As a user
  I want to create a message
  So that I can send a message to my friend
} do

  # Acceptance Criteria
  # [] I must be logged in
  # [] I must specify a receiver
  # [] The message receiver must be a friend or an inverse friend
  # [] I can choose a receiver from a drop-down menu
  # [] I must provide a message of valid length
  # [] When I click send, I receive an alert that my message is not secure, and
  #    the option to cancel or continue
  # [] When I send a message, I am given a success message
  # [] If I am unable to send a message, I can see a list of errors

end
