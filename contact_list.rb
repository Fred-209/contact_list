# Sinatra app to manage contacts for multiple users

require 'sinatra'

require_relative 'lib/contact_storage'
require_relative 'lib/user_logins'

configure do 
  enable :sessions
  set :session_secret, "its_a_secret"
end

configure(:development) do 
  require 'sinatra/reloader'
  require 'pry'
  also_reload "/css/main.css"
  also_reload "../lib/contact_storage.rb"
end 

before do 
  @user_list = UserLogins.new
  @contact_storage = ContactStorage.new
  
end

helpers do 

  def signed_in? 
    session[:signed_in]
  end

  def invalid_characters_in_login?(username, password)
     username =~ /\W/ || password =~ /\s/
  end

  def get_contacts_for_username(username)
    contact_list = @contact_storage.user_contact_list(username.to_sym)
    
    return [] unless contact_list
    contact_list.map { |contact| contact.to_h}
  end

end

 #==============================================================================

# ROUTES

not_found do 
  session[:message]= "That page cannot be found."
  redirect "/"
end

# Home
get '/' do 
  
  if signed_in? 
    redirect "/list/#{session[:username] }"
  else
    erb(:sign_in)
  end
end

# Sign in page form 
get '/sign_in' do 

  erb(:sign_in)
end

post '/sign_in' do 
  @username = params['username']
  @password = params['password']

  if @user_list.has_user?(@username)
    if @user_list.correct_user_password?(@username, @password)
      session[:signed_in] = true;
      session[:message] = "#{@username} has successfully signed in."
      session[:username] = @username

      redirect "/list/#{@username}"
    else
      session[:message] = "Invalid password. Try again."

      erb (:sign_in)
    end
  else  
    session[:message] = "Username not found. Try logging in again."

    erb (:sign_in)
  end
end

# Shows contact list for a signed in user
get '/list/:username' do 
  if signed_in?
    @contacts = get_contacts_for_username(session[:username])

    erb(:show_contacts)
  else
    redirect "/"
  end
end

# new user signup form
get '/new_user' do 
  erb(:new_user)
end

# creates a new user
post '/new_user' do 
  @username = params['username'].downcase.strip
  @password = params['password'].strip

  if invalid_characters_in_login?(@username, @password)
     session[:message] = "Only letters, numbers, and underscores are allowed in your username. No spaces allowed in password."
    erb(:new_user)
  elsif @user_list.has_user?(@username)
    session[:message] = "That username already exists."
    erb(:new_user)
  else
    @user_list.create_user(@username, @password)
    @contact_storage[@username.downcase.to_sym] = []

    session[:message] = "New user #{@username} has been created."
    session[:signed_in] = true
    session[:username] = @username

    redirect ("/list/#{@username}")
  end
end

# Create a new contact form
get '/create_contact' do 
  redirect "/" unless signed_in?

  @username = session[:username]

  erb(:create_contact)
end

#Add a new contact to a user's storage
post "/create_contact" do
  contact_params = {
    first_name: params['first_name'],
    last_name: params['last_name'],
    email: params['email'],
    telephone: params['telephone']
  }
  
  @contact_storage.create_contact(session[:username].to_sym, contact_params)
  session[:message] = "New Contact Added to Storage"

  redirect "/"
end



# Sign out current user
post "/sign_out" do 
  session.delete(:username)
  session[:signed_in] = false
  session[:message] = "Successfully signed out"

  redirect "/"
end

