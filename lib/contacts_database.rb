require 'bcrypt'
require 'pg'

class ContactsDatabase
  #stores Contact objects for an associated username
  
  attr_accessor :storage

  def initialize(logger=nil)
    @storage = PG.connect(dbname:'contacts_management' )
    @logger = logger if logger
    setup_schema
  end

  def disconnect
    @storage.close
  end

  def query(statement, *params)
    @logger.info "#{statement} : #{params}"
    @storage.exec_params(statement, params)
  end

  # returns an array of hash-contacts
  def user_contact_list(username)
    user_id = find_id_of_username(username)
    
    sql = "SELECT * FROM contacts 
           WHERE user_id = $1;"
    result = query(sql, user_id)

    contact_list = []
    result.each { |row| contact_list << row }
    contact_list
  end

  # creates a new contact from given parameters
  def create_contact(username, params)
    params << find_id_of_username(username)
    sql = "INSERT INTO contacts (first_name, last_name, email, telephone, user_id)
            VALUES ($1, $2, $3, $4, $5);"
    
    query(sql, *params)
  end

  def delete_contact(username, contact_id)
    user_id = find_id_of_username(username)
    sql = "DELETE FROM contacts WHERE id = $1 AND user_id = $2"
    query(sql, contact_id, user_id)
  end


  def update_contact(username, contact_id, new_details)
    user_id = find_id_of_username(username)
    sql = "UPDATE contacts
           SET first_name = $1,
           last_name = $2,
           email = $3,
           telephone = $4
           WHERE id = $5"
    query(sql, *new_details, contact_id)
  end


  def create_user(username, password)
    # adds a new user to @users and saves it to file
    return "Username already exists" if username_exists?(username)

    bcrypt_password = hash_password(password)
    salt = bcrypt_password.salt
    checksum = bcrypt_password.checksum
    hashed_password = salt + checksum

    sql = "INSERT INTO users (username, password)
            VALUES ($1, $2);"
    query(sql, username.downcase, hashed_password)
   end

  def delete_user(username)
    puts "Username #{username} not found" unless username_exists?(username)
    sql = "DELETE FROM users WHERE username = $1"
    query(sql, username)
  end 

  def correct_user_password?(username, password)
    sql = "SELECT password FROM users WHERE username = $1;"
    result = query(sql, username)

    BCrypt::Password.new(result.values.first.first) == password
  end

  def username_exists?(username)
    sql = "SELECT username FROM users WHERE username = $1;"
    result = query(sql, username)
    !result.values.empty?
  end
 

  private

  def hash_password(password)
    # hashes a given password using BCrypt

    BCrypt::Password.create(password)
  end

  def find_id_of_username(username)
    sql = "SELECT id FROM users WHERE username = $1"
    result = query(sql, username)
    result.values.first.first.to_i
  end


  def setup_schema
    result = @storage.exec <<~SQL
      SELECT COUNT(*) FROM information_schema.tables
      WHERE table_schema = 'public' AND table_name = 'users';
    SQL

    if result[0]["count"] == "0"
      @storage.exec <<~SQL
        CREATE TABLE users (
          id serial PRIMARY KEY,
          username varchar(20) UNIQUE NOT NULL,
          password text NOT NULL
        );
      SQL
    end

    result = @storage.exec <<~SQL
      SELECT COUNT(*) FROM information_schema.tables
      WHERE table_schema = 'public' AND table_name = 'contacts';
    SQL

    if result[0]["count"] == "0"
      @storage.exec <<~SQL
        CREATE TABLE contacts (
          id serial PRIMARY KEY,
          first_name varchar(20) NOT NULL,
          last_name varchar(20) NOT NULL,
          email varchar(50),
          telephone char(10),
          user_id int REFERENCES users(id) ON DELETE CASCADE NOT NULL
        );
      SQL
    end
  end

end


