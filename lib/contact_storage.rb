require 'yaml'
require_relative 'contact'

if ENV['RACK_ENV'] == 'test'
  STORAGE_FILE = File.expand_path("../../tests/contact_storage_test.yml", __FILE__)
else
  STORAGE_FILE = File.expand_path("../../data/contact_storage.yml", __FILE__)
end

class ContactStorage
  #stores Contact objects for an associated username

  attr_accessor :storage

  def initialize
    @storage = load_contacts_from_yaml(STORAGE_FILE)
    
  end

  # returns an array of contact objects for a given username
  def user_contact_list(username)
    storage[username]
  end

  # creates a new contact from given parameters
  def create_contact(username, parameters)
    contact = Contact.new(parameters)

    @storage[username] ||= []
    @storage[username] << contact

    save_contacts_to_yaml(STORAGE_FILE)
  end

  def delete_contact(username)
    @storage.delete(username)

    save_contacts_to_yaml(STORAGE_FILE)
  end

  def [](username)
    @storage[username]
  end

  def has_user?(username)
    @storage.has_key?(username)
  end

  def correct_password?(username, password)
    @storage[username]
  end

  private

  def load_contacts_from_yaml(file_name)
    yaml_contacts = YAML.load_file(file_name, symbolize_names: true)
    
    yaml_contacts.transform_values do |contact_list|
      contact_list.map do |contact_hash|
        Contact.new(contact_hash)
      end
    end
  end

  def save_contacts_to_yaml(file_name)
    yaml_contacts = @storage.transform_values do |contact_list|
      contact_list.map { |contact| contact.to_h}
    end

    File.write(file_name, YAML.dump(yaml_contacts))
  end

end

