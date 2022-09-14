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

  also_reload "/css/main.css"
  also_reload "../lib/contact_storage.rb"
end 

before do 
  @user_list = UserLogins.new
  @contacts_storage = ContactStorage.new
end

helpers do 

  def signed_in? 
    session[:signed_in]
  end

end

# ROUTES

# Home
get '/' do 
  
  if signed_in? 
    session[:message] = "Looks like #{session[:username]} is signed in."
    redirect '/list/#{session[:username] }'
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
    if @user_list.valid_user_password?(@username, @password)
      session[:message] = "#{@username} has successfully signed in."
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
  "Hey #{params['username']}, you're signed in!"
end

# new user signup form
get '/new_user' do 
  erb(:new_user)
end

# creates a new user
post '/new_user' do 

end
