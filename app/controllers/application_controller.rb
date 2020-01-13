require "./config/environment"
require "./app/models/user"
class ApplicationController < Sinatra::Base

  configure do
    set :views, "app/views"
    enable :sessions
    set :session_secret, "password_security"
  end

  get "/" do # get "/" do renders an index.erb file with links to signup or login.
    erb :index
  end

  get "/signup" do # get '/signup' renders a form to create a new user.
    erb :signup # The form includes fields for username and password.
  end

  post "/signup" do # creates a new user object with a username and a password
     @user = User.new(username: params[:username], password: params[:password])
     
    if @user.save
      redirect '/account'
    else
      redirect '/failure'
    end
  end

  get '/account' do # get '/account' renders an account.erb page,
    @user = User.find(session[:user_id]) # which should be displayed once a user successfully logs in.
    erb :account
  end


  get "/login" do # get '/login' renders a form for logging in.
    erb :login
  end

  post "/login" do ##your code here
    user = User.find_by(:username => params[:username])

    if user && user.authenticate(params[:password]) # if user is true and user.authenticates the password
      session[:user_id] = user.id # We set the session hash user_id = to the user.id
      redirect '/account'
    else
      redirect '/failure'
    end
  end

  get "/failure" do # get '/failure' renders a failure.erb page. 
    erb :failure # This will be accessed if there is an error logging in or signing up.
  end

  get "/logout" do # get '/logout' clears the session data and redirects to the home page.
    session.clear
    redirect "/"
  end

  # The Helper Methods at the bottom of the controller are part of Sinatra's configurations for helper methods. 
  # These are methods that allow us to add logic to our views. 
  # Views automatically have access to all helper methods thanks to Sinatra.

  helpers do
    def logged_in?
      !!session[:user_id]
    end

    def current_user
      User.find(session[:user_id])
    end
  end

end
