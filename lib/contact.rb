class Contact
  # Stores data about an individual contact

  attr_accessor :id, :first_name, :last_name, :email, :telephone

  def initialize(contact_params)
    @id = contact_params[:id]
    @first_name = contact_params[:first_name]
    @last_name = contact_params[:last_name]
    @email = contact_params[:email]
    @telephone = contact_params[:telephone]
  end

  def all_info
    [@id, @first_name, @last_name, @email, @telephone]
  end

  def to_h
    { 
      id: @id,
      first_name: @first_name,
      last_name: @last_name,
      email: @email,
      telephone: @telephone
    }
  end

  

  
end

