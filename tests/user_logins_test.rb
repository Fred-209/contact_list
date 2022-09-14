require 'minitest/autorun'
require "minitest/reporters"
Minitest::Reporters.use!

require 'bcrypt'

require_relative '../lib/user_logins.rb'


class UserLoginsTest < Minitest::Test

  def setup
    @users = UserLogins.new
    @user_list = @users.user_list
    @test_username = 'test_user'
    @test_password = 'secret'
  end

  def teardown
    @users.delete_user(@test_username) if @user_list.include?(@test_username)
  end

  def test_file_load
    yaml_file = YAML.load_file('../data/user_logins.yml')
    users_list = @users.user_list

    assert_equal(yaml_file, users_list)
  end
  
  def test_create_user
    hashed_password = BCrypt::Password.create(@test_password)
    @users.create_user(@test_username, @test_password)

    stored_hashed_password = BCrypt::Password.new(@user_list[@test_username])

    assert_includes(@user_list, @test_username)
    assert_equal(stored_hashed_password, @test_password)
  end

  def test_valid_user_password
    @users.create_user(@test_username, @test_password)

    assert_equal(true, @users.valid_user_password?(@test_username, @test_password))
    refute_equal(true, @users.valid_user_password?(@test_username, 'bogus_password'))
  end

end