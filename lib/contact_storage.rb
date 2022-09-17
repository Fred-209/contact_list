require 'yaml'
require_relative 'contact'
require 'pry'

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
    parameters[:id] = next_contact_id(username)
    contact = Contact.new(parameters)

    @storage[username] ||= []
    @storage[username] << contact

    save_contacts_to_yaml(STORAGE_FILE)
  end

  # def delete_contact(username)
  #   @storage.delete(username)

  #   save_contacts_to_yaml(STORAGE_FILE)
  # end

  def [](username)
    @storage[username]
  end

  def []=(key, value)
    @storage[key] = value
  end

  def has_user?(username)
    @storage.has_key?(username)
  end

  def correct_password?(username, password)
    @storage[username]
  end

  def delete_contact(username, id)
    @storage[username].delete_if { |contact| contact.id == id.to_i}
    save_contacts_to_yaml(STORAGE_FILE)
  end

  # @contact_storage.update_contact(username, contact_id, new_contact_info)

  def update_contact(username, contact_id, new_details)
    contact = find_username_contact_by_id(username, contact_id)

    contact.first_name = new_details[:first_name]
    contact.last_name = new_details[:last_name]
    contact.email = new_details[:email]
    contact.telephone = new_details[:telephone]
    save_contacts_to_yaml(STORAGE_FILE)
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

  def next_contact_id(username)
    max = @storage[username].map { |contact| contact.id}.max || 0
    p max
    (max + 1)
  end

  def find_username_contact_by_id(username, contact_id)
    p username
    storage[username].find { |contact| contact.id == contact_id }
  end

end


test = ContactStorage.new
test.delete_contact(:admin, '6')