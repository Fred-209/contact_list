ENV["RACK_ENV"] = "test"

require 'minitest/autorun'
require 'minitest/reporters'
require 'rack/test'
Minitest::Reporters.use!

require_relative "../contact_list"

TEST_STORAGE_FILE = "contact_storage_test.yml"

class ContactListTest < Minitest::Test
  include Rack::Test::Methods

  def app 
    Sinatra::Application
  end

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

  def test_index
    get "/"
    
    assert_equal 200, last_response.status
    assert_equal "text/html;charset=utf-8", last_response["Content-Type"]
    assert_match /Contact List App/, last_response.body
  end
  
end