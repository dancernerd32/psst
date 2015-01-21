require "csv"
module EncryptionHelper
  def assign_secret_key
    primes = []

    CSV.foreach("primes_test.csv") do |row|
      primes << row
    end

    length = primes.length - 1

    key = [primes[rand(length)], primes[rand(length)]]

    while key[0] == key[1]
      key = [primes[rand(length)], primes[rand(length)]]
    end

    key
  end
end
