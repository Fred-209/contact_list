ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require "minitest/reporters"
Minitest::Reporters.use!

require_relative '../lib/contact.rb'


class ContactTest < Minitest::Test
  
  def setup
    first_name = 'Mikey'
    last_name = "Callahan"
    email = "mcallahan@launchschool.com"
    telephone = "18004443333"
    params = { 
              first_name:first_name,
              last_name: last_name, 
              email: email, 
              telephone: telephone 
             }
    @contact = Contact.new(params)
  end

  def test_contact_info
    expected = ['Mikey', 'Callahan', 'mcallahan@launchschool.com', '18004443333']

    assert_equal expected, @contact.all_info
  end

  def test_contact_to_h
    contact_hash = {first_name: 'Mikey', last_name: 'Callahan', 
                    email: "mcallahan@launchschool.com", telephone: "18004443333"}

    assert_equal(contact_hash, @contact.to_h)
  end
end