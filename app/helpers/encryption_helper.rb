require "csv"

module EncryptionHelper
  def assign_secret_key
    primes = []

    CSV.foreach("primes_test.csv") do |row|
      primes << row.first.to_i
    end

    length = primes.length - 1

    key = [primes[rand(length)], primes[rand(length)]]

    while key[0] == key[1]
      key = [primes[rand(length)], primes[rand(length)]]
    end

    key
  end

  def euclidean_algorithm(a, b)
    if b > a
      placeholder_a = a
      a = b
      b = placeholder_a
    end
    euclidean_algorithm = [[a, a / b, b, a % b]]
    n = 0
    while euclidean_algorithm[n][3] > 0
      iteration = [euclidean_algorithm[n][2],
                   euclidean_algorithm[n][2] / euclidean_algorithm[n][3],
                   euclidean_algorithm[n][3],
                   euclidean_algorithm[n][2] % euclidean_algorithm[n][3]]
      euclidean_algorithm << iteration

      n += 1
    end
    euclidean_algorithm
  end

  def extended_euclidean_algorithm(phi_of_m, k)
    u_array = [0, 1]
    q_array = []
    euclidean_algorithm(phi_of_m, k).each do |iter|
      q_array << iter[1]
    end
    q_array.pop

    q_array.each_with_index do |q, i|
      u_array << ((u_array[i] - u_array[i + 1] * q) % phi_of_m)
    end
    u_array.last
  end

  def gcd(a, b)
    e_a = euclidean_algorithm(a, b)
    if e_a.length > 1
      e_a[e_a.length - 2][3]
    else
      e_a[0][2]
    end
  end

  def calculate_public_key(p, q)
    m = p * q
    phi_of_m = (p - 1) * (q - 1)

    k = rand(10000000)

    while gcd(phi_of_m, k) != 1
      k = rand(10000000)
    end

    [m, k]
  end

  def encoder_hash
    { "a" => "11", "b" => "12", "c" => "13", "d" => "14", "e" => "15",
      "f" => "16", "g" => "17", "h" => "18", "i" => "19", "j" => "20",
      "k" => "21", "l" => "22", "m" => "23", "n" => "24", "o" => "25",
      "p" => "26", "q" => "27", "r" => "28", "s" => "29", "t" => "30",
      "u" => "31", "v" => "32", "w" => "33", "x" => "34", "y" => "35",
      "z" => "36"
    }
  end

  def decoder_hash
    decoder_hash = {}

    encoder_hash.each do |k, v|
      decoder_hash[v] = k
    end
    decoder_hash
  end

  def encode(message)
    # strips message and puts each letter into it's own space in an array
    message_array = message.downcase.gsub(/[^a-z]/, "").split("")
    encoded_message = []
    message_array.each do |letter|
      encoded_message << encoder_hash[letter]
    end
    encoded_message.join("")
    # returns encoded message as a string of digits
  end

  def split_message(message, m)
    x = 0
    split_message = []
    length = m.to_s.length - 1
    while x < message.length
      split_message << message.slice(x, length)
      x += (length)
    end
    split_message
  end

  def successive_squaring(number, m, k)
    x_array = []
    while k > 0
      x = Math.log2(k).to_i
      x_array << x
      k -= 2**x
    end

    successive_squaring = [number.to_i]
    x = x_array.first
    x.times do
      number = number.to_i**2 % m
      successive_squaring << number
    end

    product = 1

    x_array.each do |y|
      product *= successive_squaring[y]
      product %= m
    end
    product
  end

  def encrypt(message, m, k)
    message = encode(message)
    # splits string into an array of |number|s which are m-1 digits long
    split_message = split_message(message, m)

    encrypted_message_array = []

    # raises each of these numbers to the kth power mod m (using successive
    # squaring) and puts them into an array
    split_message.each do |piece|
      n = successive_squaring(piece, m, k)
      encrypted_message_array << n
    end
    encrypted_message_array.join(", ")
  end

  # def create_gobilty_gook(encrypted_message)
  #   # takes encrypted message and splits it into an array with two digits in
  #   # each space
  #   # maybe using a loop and slice
  #   # loops through array and creates new array using decoder_hash
  #   # returns gobilty_gook
  # end

  def decrypt(message, p, q, m, k)
    message = message.split(", ")
    phi_of_m = (p - 1) * (q - 1)
    u = extended_euclidean_algorithm(phi_of_m, k)

    decrypted = []
    message.each do |piece|
      decrypted << successive_squaring(piece.to_i, m, u)
    end

    decrypted_string = decrypted.join("")
    x = 0
    split_message = []
    while x < decrypted_string.length
      split_message << decrypted_string.slice(x, 2)
      x += 2
    end

    decoded_message = []
    split_message.each do |number|
      decoded_message << decoder_hash[number]
    end
    decoded_message.join("")
  end
end
