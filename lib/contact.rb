class Contact
  # Stores data about an individual contact

  def intitialize(contact_params)
    @first_name = contact_params[:first_name]
    @last_name = contact_params[:last_name]
    @email = contact_params[:email]
    @telephone = contact_params[:telephone]

  end
  
end