ENV['RACK_ENV'] = 'test'


require 'minitest/autorun'
require "minitest/reporters"
Minitest::Reporters.use!

require_relative '../lib/contact_storage'

TEST_STORAGE_FILE = "contact_storage_test.yml"

class ContactStorageTest < Minitest::Test

  def setup
    @test_username = 'Tester'
    @test_values = [{first_name: 'Test', last_name: 'McTestFace', email: 'testy@tester.com',
              telephone: '7778889999'}]

    File.write(TEST_STORAGE_FILE, YAML.dump( {@test_username => @test_values} ))
    @storage = ContactStorage.new
  end

  def teardown
    File.delete(TEST_STORAGE_FILE)
  end
   
  def test_create_contact
    username = 'Tester'
    values = {first_name: 'Test', last_name: 'McTestFace', email: 'testy@tester.com',
              telephone: '7778889999'}
    @storage.create_contact(username, values)

    assert_equal(values, @storage[username].first.to_h)
  end

  def test_delete_contact
    @storage.create_contact(@test_username, @test_values.first)
    assert_includes @storage.storage, @test_username

    @storage.delete_contact(@test_username)
    refute_includes @storage.storage, @test_username

  end

  def test_has_user?
    @storage.create_contact(@test_username, @test_values.first)

    assert(@storage.has_user?(@test_username))
  end
end