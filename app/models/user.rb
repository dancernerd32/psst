require "csv"
class User < ActiveRecord::Base
  has_many :friendships, dependent: :destroy
  has_many :friends, through: :friendships
  has_many :inverse_friendships,
           class_name: "Friendship",
           foreign_key: "friend_id",
           dependent: :destroy
  has_many :inverse_friends, through: :inverse_friendships, source: :user
  has_many :posts, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

   def assign_secret_key
     primes = []

     CSV.foreach("primes.csv") do |row|
       primes << row
     end

     length = primes.length - 1

     key = [primes[rand(length)], primes[rand(length)]]

     while key[0] == key[1]
       key = [primes[rand(length)], primes[rand(length)]]
     end

     key
   end

  attr_accessor :login

  validates :username,
            presence: true,
            uniqueness: {
              case_sensitive: false
            }

  validates :first_name,
            presence: true

  validates :last_name,
            presence: true

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where([
        "lower(username) = :value OR lower(email) = :value",
        { value: login.downcase }
      ]).first
    else
      if conditions[:username].nil?
        where(conditions).first
      else
        where(username: conditions[:username]).first
      end
    end
  end
end
