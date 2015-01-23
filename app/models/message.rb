class Message < ActiveRecord::Base
  belongs_to :sender, class_name: "User"
  belongs_to :recipient, class_name: "User"

  validates :body, presence: true, length: { minimum: 100 }
  validates :public_key_m, presence: true
  validates :public_key_k, presence: true
  validates :recipient, presence: true
end
