require 'bcrypt'
require 'yaml'

FILE_NAME = File.expand_path("../../data/user_logins.yml", __FILE__)

class UserLogins
  # Stores a list of users/passwords in a yml file
  # Contains methods associated with the retrieval, storage, and validation of 
  # this list of usernames and passwords

  attr_reader :user_list

  def initialize
    @user_list = load_users_list
  end

  def create_user(username, password)
    # adds a new user to @user_list and saves it to file
    return "Username already exists" if @user_list.has_key?(username)

    hashed_password = hash_password(password)
    salt = hashed_password.salt
    checksum = hashed_password.checksum

    @user_list[username.downcase] = salt + checksum
    puts "#{username} added to the database"
    save_users_list
  end

  def delete_user(username)
    puts "Username #{username} not found" unless user_list.has_key?(username)

    user_list.delete(username)
    puts "#{username} deleted from the database"

    save_users_list
  end 

  def correct_user_password?(username, password)
    BCrypt::Password.new(user_list[username]) == password
  end


  def has_user?(username)
    @user_list.has_key?(username)
  end

  private
  
  def load_users_list
    # loads users list from existing file user_logins.yml in the /data directory

    YAML.load_file(FILE_NAME)
  end

  def save_users_list
    #saves current @user_list to a yaml file
    
    File.write(FILE_NAME, YAML.dump(@user_list))
    
  end

  def hash_password(password)
    # hashes a given password using BCrypt

    BCrypt::Password.create(password)
  end

end


