get '/profile/?' do
  allowed [:user]
  @profile = User.get(session[:user])
  erb :profile
end

post '/users/?' do
  if params[:state] == 'all'
    redirect '/users'
  else
    redirect "/users?state=#{params[:states]}"
  end
end

get '/users/?' do
	allowed [:admin, :state_customer, :ngb_customer, :regional]
	
	if session[:regional]
	  r = User.get(session[:user]).region.id
    @users = Region.get(r).users
  elsif session[:state_customer]
    s = User.get(session[:user]).state_id
    @users = State.get(s).users
  else
    @users = User.all
  end

	if params[:show] && params[:show] == 'deactive'
	  @users = @users.all(:active => 'f')
  else
    @users = @users.all(:active => 't')
  end
  
  if params[:state]
    unless params[:state] == 'all'
      s_id = State.first(:abbr => params[:state]).id
      @users = @users.all(:state_id => s_id)
    end
  end
  
  @users = @users.all(:admin => 'f') unless session[:admin]
  @users = @users.all(:state_customer => 'f') if session[:ngb_customer]
  
  if session[:state_customer]
	  @users = @users.all(:ngb_customer => 'f')
	  
	  current_state = User.get(session[:user]).state_id
	  @users = @users.all(:state_id => current_state)
	end
  
	erb :users
end

get '/users/new/?' do
	allowed [:admin]
	@user = User.new
	erb :user
end

post '/users/new/?' do
	allowed [:admin]
	
	user = User.create(
		:emp_date   => Chronic.parse("#{params[:emp_date_year]}-#{params[:emp_date_month]}-#{params[:emp_date_day]}"),
		:email			=> params[:email].strip.downcase,
		:password		=> params[:password].strip.downcase,
		:first_name => params[:first_name],
		:last_name	=> params[:last_name],
		:title			=> params[:title],
		:state_id	  => params[:state],
		:address1		=> params[:address1],
		:address2		=> params[:address2],
		:city				=> params[:city],
		:zip				=> params[:zip],
    :area				=> params[:area],
		:phone1			=> params[:phone1],
		:phone2			=> params[:phone2],
		:phone3			=> params[:phone3],
		:bio				=> params[:bio],
		:linkedin		=> params[:linkedin]
	)
	params[:admin] 						? user.update(:admin => true) 					 : user.update(:admin => false)
	params[:educator_liaison] ? user.update(:educator_liaison => true) : user.update(:educator_liaison => false)
	params[:regional] 				? user.update(:regional => true) 				 : user.update(:regional => false)
	params[:state_customer] 	? user.update(:state_customer => true) 	 : user.update(:state_customer => false)
	params[:ngb_customer] 		? user.update(:ngb_customer => true) 		 : user.update(:ngb_customer => false)
  params[:nc_el] 		        ? user.update(:nc_el => true) 		       : user.update(:nc_el => false)
	
	File.open("public/images/users/#{user.id}.jpg", 'wb') { |file| file.write(params[:pic][:tempfile].read) } if params[:pic]
	
	session[:alert] = {
    style: 'alert-success',
    message: 'Profile has been created.'
  }
	redirect '/users'
end

get '/users/:id/profile/?' do
	allowed [:admin, :state_customer, :ngb_customer, :regional]
  @profile = User.get(params[:id])
  if session[:regional]
    redirect '/users' unless @profile.region.id == User.get(session[:user]).region.id
  elsif session[:state_customer]
    redirect '/users' unless @profile.state_id == User.get(session[:user]).state_id
  end
  erb :profile
end

get '/users/:id/?' do
	@user = User.get(params[:id])
	redirect '/' unless session[:admin] || @user.id == session[:user]
	erb :user
end

post '/users/:id/?' do  
  user = User.get(params[:id])
  redirect '/' unless session[:admin] || user.id == session[:user]
  user.update(
		:emp_date   => Chronic.parse("#{params[:emp_date_year]}-#{params[:emp_date_month]}-#{params[:emp_date_day]}"),
		:email			=> params[:email].strip.downcase,
		:password		=> params[:password].strip.downcase,
		:first_name => params[:first_name],
		:last_name	=> params[:last_name],
		:title			=> params[:title],
		:state_id	  => params[:state],
		:address1		=> params[:address1],
		:address2		=> params[:address2],
		:city				=> params[:city],
		:zip				=> params[:zip],
    :area				=> params[:area],
		:phone1			=> params[:phone1],
		:phone2			=> params[:phone2],
		:phone3			=> params[:phone3],
		:bio				=> params[:bio],
		:linkedin		=> params[:linkedin]
  )
	params[:admin] 						? user.update(:admin => true) 					 : user.update(:admin => false)
	params[:educator_liaison] ? user.update(:educator_liaison => true) : user.update(:educator_liaison => false)
	params[:regional] 				? user.update(:regional => true) 				 : user.update(:regional => false)
	params[:state_customer] 	? user.update(:state_customer => true) 	 : user.update(:state_customer => false)
  params[:nc_el] 		        ? user.update(:nc_el => true) 		       : user.update(:nc_el => false)
	
	File.open("public/images/users/#{user.id}.jpg", 'wb') { |file| file.write(params[:pic][:tempfile].read) } if params[:pic]
	  
  session[:alert] = {
    style: 'alert-success',
    message: 'Profile has been updated.'
  }
  redirect '/users'
end

get '/users/:id/delete/?' do
	allowed [:admin]
	user = User.get(params[:id])
	user.destroy
	session[:alert] = {
    style: 'alert-success',
    message: 'user deleted successfully!'
  }
	redirect '/users'
end

get '/users/:id/activate/?' do
  allowed [:admin]
  user = User.get(params[:id])
  user.update(:active => true)
  session[:alert] = {
    style: 'alert-success',
    message: 'user activated!'
  }
	redirect '/users'
end

get '/users/:id/deactivate/?' do
  allowed [:admin]
  user = User.get(params[:id])
  user.update(:active => false)
  session[:alert] = {
    style: 'alert-success',
    message: 'user deactivated!'
  }
	redirect '/users'
end

get '/api/elps/:state_abbr/?' do
  elp_list = []
  params[:state_abbr].strip!
  params[:state_abbr].upcase!
  if state = State.first(abbr: params[:state_abbr])
    elps  = state.users.all(active: true, educator_liaison: true)
    elp_list = elps.map(&:email)
  end
  elp_list.to_s
end

class User
	include DataMapper::Resource

	property   :id,         Serial
	property   :deleted_at, ParanoidDateTime
	timestamps :at

  property  :emp_date,    Date,   :default => Chronic.parse('now')
  property  :email,       String#, :required => true
  property  :password,    String
  property  :first_name,  String
  property  :last_name,   String
  property  :title,       String
  property  :address1,    String
  property  :address2,    String
  property  :city,        String
  property  :zip,         String
  property  :area,        String
  property  :phone1,      String
  property  :phone2,      String
  property  :phone3,      String
  property  :bio,         Text
  property  :linkedin,    String
  
  property  :admin,       			Boolean, :default => false
  property  :educator_liaison,	Boolean, :default => false
  property  :regional,       		Boolean, :default => false
  property  :state_customer,    Boolean, :default => false
  property  :ngb_customer,      Boolean, :default => false
  property  :nc_el,             Boolean, :default => false
  
  property  :active,            Boolean, :default => true
  
  belongs_to  :state
  has 1,      :region, {:through=>:state}
  has n,      :reports
  has n,      :contacts
  has n,      :expense_reports
  
  def display_name
    "#{self.first_name} #{self.last_name}"
  end
  
  def display_address
    address = ''
    address << "#{self.address1}<br />" if self.address1 && self.address1.strip.length > 0
    address << "#{self.address2}<br />" if self.address2 && self.address2.strip.length > 0
    address << "#{self.city}, " if self.city && self.city.strip.length > 0
    address << "#{self.state.abbr} " if self.state
    address << "#{self.zip}" if self.zip && self.zip.strip.length > 0
    address
  end

end