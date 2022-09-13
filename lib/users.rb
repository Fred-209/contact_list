require 'bcrypt'
require 'yaml'


class Users
  # Stores a list of users/passwords in a yml file
  # Contains methods associated with the retrieval, storage, and validation of 
  # this list of usernames and passwords

  def initialize
    @user_list = load_users_list

  end

  def create_user(username, password)
    # adds a new user to @user_list and saves it to file
    hashed_password = hash_password(password)
    @user_list << {username: username, password: hashed_password }
    save_users_list
  end

  def retrieve_user(username)

  end

  

  private
  
  def load_users_list
    # loads users list from existing file users.yml in the /data directory8
  end

  def save_users_list
    #saves current @user_list to users.yml in /data directory
    
  end

  def hash_password(password)
    # hashes a given password using BCrypt
  end

end