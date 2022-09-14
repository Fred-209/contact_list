ENV["RACK_ENV"] = "test"

require 'minitest/autorun'
require 'minitest/reporters'
require 'rack/test'
Minitest::Reporters.use!

require_relative "../contact_list"

class ContactListTest < Minitest::Test
  include Rack::Test::Methods

  def app 
    Sinatra::Application
  end

  def test_index
    get "/"
    
    assert_equal 200, last_response.status
    assert_equal "text/html;charset=utf-8", last_response["Content-Type"]
    assert_equal "Getting Started", last_response.body
  end
end