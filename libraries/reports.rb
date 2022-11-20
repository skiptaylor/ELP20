# get '/users/:user_id/reports/summary/pdf/?' do
#   Prawn::Document.generate("hello.pdf", :skip_page_creation => true) do
#     text "Hello World!"
#   end
# end

get '/users/:user_id/reports/?' do

	access  = true	
	if session[:admin] || session[:ngb_customer]
		access = true
	elsif session[:regional]
		access = false unless User.get(params[:user_id]).region.id == User.get(session[:user]).region.id
	elsif session[:state_customer]
		access = false unless User.get(params[:user_id]).state_id  == User.get(session[:user]).state_id
	elsif session[:user]
		access = false unless params[:user_id].to_i == session[:user].to_i
	else
		access = false
	end
	if access == false
		session[:alert] = {
    	style: 'alert',
    	message: 'You are not allowed to see this page!'
    }
		redirect '/elp'
	end
  
  if params[:search] && params[:search].strip.length > 0
    user_reports  = Report.all(:user_id => params[:user_id])
    school        = user_reports.all(:school.like         => "%#{params[:search]}%")
    zip           = user_reports.all(:zip.like            => "%#{params[:search]}%")
    description   = user_reports.all(:description.like    => "%#{params[:search]}%")
    rrnco_name    = user_reports.all(:rrnco_name.like     => "%#{params[:search]}%")
    host_educator = user_reports.all(:host_educator.like  => "%#{params[:search]}%")
    c_name        = Contact.all(:name.like      => "%#{params[:search]}%").reports.all(:user_id => params[:user_id])
    c_source      = Contact.all(:source.like    => "%#{params[:search]}%").reports.all(:user_id => params[:user_id])
    c_title       = Contact.all(:title.like     => "%#{params[:search]}%").reports.all(:user_id => params[:user_id])
    c_location    = Contact.all(:location.like  => "%#{params[:search]}%").reports.all(:user_id => params[:user_id])
    c_phone       = Contact.all(:phone.like     => "%#{params[:search]}%").reports.all(:user_id => params[:user_id])
    c_email       = Contact.all(:email.like     => "%#{params[:search]}%").reports.all(:user_id => params[:user_id])
    @reports = school | zip | description | rrnco_name | host_educator | c_name | c_source | c_title | c_phone | c_email
  elsif params[:month] && params[:year]
    start_date = Chronic.parse("#{params[:month]} 1, #{params[:year]}")
    unless start_date.month == 12
      end_month = start_date.month + 1
      end_year = start_date.year
    else
      end_month = 1
      end_year = start_date.year + 1
    end  
    end_date = Chronic.parse("#{end_year}-#{end_month}-1")
    @reports = Report.all(:user_id => params[:user_id], :date.lt => end_date, :date.gte => start_date, :order => :date.asc)
  elsif params[:show] == 'all'
  	@reports = Report.all(:user_id => params[:user_id], :order => :date.desc)
  elsif params[:show] == '30days'
    @reports = Report.all(:user_id => params[:user_id], :created_at.gte => Chronic.parse('1 month ago'), :order => :date.desc)
  else
  	@reports = Report.all(:user_id => params[:user_id], :order => :date.desc, :limit => 30)
  end
  
  erb :'reports/reports'
end

post '/reports/search/:method/?' do
  erb :'reports/search', :layout => false, :locals => {:method => params[:method]}
end

get '/reports/contacts/:id/?' do
  params[:contact_id] ? @contact = Contact.get(params[:contact_id]) : @contact = Contact.new
  erb :'reports/contacts', :layout => false, :locals => {:contact => @contact, :index => params[:id]}
end

post '/reports/monthly/:month/:year/?' do
  redirect "/reports/monthly/#{params[:new_month]}/#{params[:new_year]}/?user=#{params[:user]}"
end

get '/reports/monthly/:month/:year/?' do
  
  redirect "/reports/monthly/#{params[:month]}/#{params[:year]}/?user=#{session[:user]}" unless params[:user]
  
	access  = true	
	if session[:admin] || session[:ngb_customer]
		access = true
	elsif session[:regional]
		access = false unless User.get(params[:user]).region.id == User.get(session[:user]).region.id
	elsif session[:state_customer]
		access = false unless User.get(params[:user]).state_id  == User.get(session[:user]).state_id
	elsif session[:user]
		access = false unless params[:user].to_i == session[:user].to_i
	else
		access = false
	end
	if access == false
		session[:alert] = {
    	style: 'alert',
    	message: 'Try again!'
    }
		redirect '/elp'
	end
  
  @user = User.get(params[:user]) 
  
  start_date = Chronic.parse("#{params[:month]} 1, #{params[:year]}")
  unless start_date.month == 12
    end_month = start_date.month + 1
    end_year = start_date.year
  else
    end_month = 1
    end_year = start_date.year + 1
  end  
  end_date = Chronic.parse("#{end_year}-#{end_month}-1")
  @reports_from_current_month = Report.all(:user_id => @user.id, :date.lt => end_date, :date.gte => start_date)

  if start_date.month < 7
    beginning_year = start_date.year - 1
  else
    beginning_year = start_date.year
  end

  start_of_year = Chronic.parse("august 1, #{beginning_year}")
  
  @reports_from_past_year_with_current_month    = Report.all(:user_id => @user.id, :date.lt => end_date, :date.gte => start_of_year)
  @reports_from_past_year_without_current_month = Report.all(:user_id => @user.id, :date.lt => start_date, :date.gte => start_of_year)
  
  erb :'reports/monthly'
end

post '/reports/summary/:month/:year/?' do
	if params[:state] && params[:state] != 'all'
		state = "?state=#{params[:state]}"
	else
		state = ''
	end
  redirect "/reports/summary/#{params[:new_month]}/#{params[:new_year]}#{state}"
end

get '/reports/summary/:month/:year/?' do  
  allowed [:admin, :ngb_customer, :regional, :state_customer]
  
  start_date = Chronic.parse("#{params[:month]} 1, #{params[:year]}")
  unless start_date.month == 12
    end_month = start_date.month + 1
    end_year = start_date.year
  else
    end_month = 1
    end_year = start_date.year + 1
  end  
  end_date = Chronic.parse("#{end_year}-#{end_month}-1")
  
  if params[:state] && params[:state] != 'all'
  	state_id = State.first(:abbr => params[:state]).id
  end
      
  if session[:regional]
  	if state_id
  		@reports = Region.get(User.get(session[:user]).region.id).users.all(:state_id => state_id, :admin => 'f', :state_customer => 'f', :ngb_customer => 'f', :nc_el => 'f').reports
  	else
  		@reports = Region.get(User.get(session[:user]).region.id).users.all(:admin => 'f', :state_customer => 'f', :ngb_customer => 'f', :nc_el => 'f').reports
  	end
  elsif session[:state_customer]
  	if state_id
  		@reports = State.get(User.get(session[:user]).state_id).users.all(:state_id => state_id, :admin => 'f', :state_customer => 'f', :ngb_customer => 'f', :nc_el => 'f').reports
  	else
  		@reports = State.get(User.get(session[:user]).state_id).users.all(:admin => 'f', :state_customer => 'f', :ngb_customer => 'f', :nc_el => 'f').reports
  	end
  else
  	if state_id
	  	@reports = User.all(:state_id => state_id, :admin => 'f', :state_customer => 'f', :ngb_customer => 'f', :nc_el => 'f').reports
	  else
			@reports = User.all(:admin => 'f', :state_customer => 'f', :ngb_customer => 'f', :nc_el => 'f').reports
		end
  end
  
  @reports = @reports.all(:date.lt => end_date, :date.gte => start_date)
    
  erb :'reports/summary'
end

post '/reports/custom_summary/:start_date/:end_date/?' do
	if params[:state] && params[:state] != 'all'
		state = "?state=#{params[:state]}"
	else
		state = ''
	end
	new_start_date = "#{params[:start_year]}-#{params[:start_month]}-#{params[:start_day]}"
	new_end_date 	 = "#{params[:end_year]}-#{params[:end_month]}-#{params[:end_day]}"
 	redirect "/reports/custom_summary/#{new_start_date}/#{new_end_date}#{state}"
end


get '/reports/asvab/?' do
  allowed [:admin]
  
  if params[:start_month] && params[:start_day] && params[:start_year]
    @start = Chronic.parse("#{params[:start_year]}-#{params[:start_month]}-#{params[:start_day]}")
  else
    @start = Chronic.parse('Jan 1, 2011')
  end

  if params[:end_month] && params[:end_day] && params[:end_year]
    @end = Chronic.parse("#{params[:end_year]}-#{params[:end_month]}-#{params[:end_day]}")
  else
    @end = Time.now
  end

	admins = []
	User.all(:admin => true).each { |u| admins << u.id }
  
  @reports = Report.all(:user_id.not => admins, :asvab_new_exists => 'new', :asvab.gt => 0, :order => :date.desc, :date.gte => @start, :date.lte => @end)
  
  @total_schools = @reports.count
  @total_students = 0
  
  @reports.each { |r| @total_students += r.asvab }
  
  if params[:csv]
  	response.headers['Content-Type'] = 'text/csv; charset=utf-8' 
  	response.headers['Content-Disposition'] = "attachment; filename=contacts.csv"
		
		file = ''
		file = CSV.generate do |csv|
			csv << ['ASVAB Students', 'School', 'Date', 'ELP Name', 'State']
			@reports.each do |r|
				csv << [
					r.asvab,
					r.school,
					format_american_day(r.date),
					"#{r.user.first_name} #{r.user.last_name}",
					r.user.state.abbr
				]
			end
		end
		
		return file
  else
  	erb :'reports/asvab'
  end
  
end


get '/reports/custom_summary/:start_date/:end_date/?' do
	allowed [:admin, :ngb_customer, :regional, :state_customer]
	
	if params[:state] && params[:state] != 'all'
		state_id = State.first(:abbr => params[:state]).id
	end

	if session[:regional]
		if state_id
			@reports = Region.get(User.get(session[:user]).region.id).users.all(:state_id => state_id, :admin => 'f', :state_customer => 'f', :ngb_customer => 'f', :nc_el => 'f').reports
		else
			@reports = Region.get(User.get(session[:user]).region.id).users.all(:admin => 'f', :state_customer => 'f', :ngb_customer => 'f', :nc_el => 'f').reports
		end
	elsif session[:state_customer]
		if state_id
			@reports = State.get(User.get(session[:user]).state_id).users.all(:state_id => state_id, :admin => 'f', :state_customer => 'f', :ngb_customer => 'f', :nc_el => 'f').reports
		else
			@reports = State.get(User.get(session[:user]).state_id).users.all(:admin => 'f', :state_customer => 'f', :ngb_customer => 'f', :nc_el => 'f').reports
		end
  else
		if state_id
			@reports = User.all(:state_id => state_id, :admin => 'f', :state_customer => 'f', :ngb_customer => 'f', :nc_el => 'f').reports
		else
			@reports = User.all(:admin => 'f', :state_customer => 'f', :ngb_customer => 'f', :nc_el => 'f').reports
		end
	end

  @reports = @reports.all(:date.lte => Chronic.parse(params[:end_date]), :date.gte => Chronic.parse(params[:start_date]))
  erb :'reports/summary'
end

get '/users/:user_id/reports/new/?' do  
  allowed [:educator_liaison, :admin, :regional, :nc_el]
  
  unless session[:admin] || params[:user_id].to_i == session[:user].to_i
  	session[:alert] = {
    	style: 'alert-error',
    	message: 'You can not create a report for another liaison.'
    }
   	redirect '/elp'
  end
  
  @report = Report.new(:user_id => params[:user_id])
  erb :'reports/form'
end

post '/users/:user_id/reports/new/?' do  
	allowed [:educator_liaison, :admin, :regional, :nc_el]
	
	unless session[:admin] || params[:user_id].to_i == session[:user].to_i
		session[:alert] = {
    	style: 'alert-error',
    	message: 'You can not create a report for another liaison.'
    }
		redirect '/elp'
	end
  
  report = Report.create(
    :user_id            => params[:user_id],
    :date               => Chronic.parse("#{params[:date_year]}-#{params[:date_month]}-#{params[:date_day]}"),
    :title              => params[:title],
    :school             => params[:school],
    :zip                => params[:zip],
    :rrnco_name         => params[:rrnco_name],
    :host_educator      => params[:host_educator],
    :rrnco_pres         => params[:rrnco_pres].to_i,
    :elp_pres           => params[:elp_pres].to_i,
    :rrnco_elp_pres			=> params[:rrnco_elp_pres].to_i,
    :asvab              => params[:asvab].to_i,
    :asvab_promo        => params[:asvab_promo].to_i,
    :cep                => params[:cep].to_i,
    :ycsp               => params[:ycsp].to_i,
    :cd                 => params[:cd].to_i,
    :hop                => params[:hop].to_i,
    :humvee             => params[:humvee].to_i,
    :pie                => params[:pie].to_i,
    :gfc                => params[:gfc].to_i,
    :hear               => params[:hear].to_i,
    :other              => params[:other].to_i,
    :other_activity			=> params[:other_activity].to_i,
    :team_leader        => params[:team_leader].to_i,
    :rrnco              => params[:rrnco].to_i,
    :trained            => params[:trained].to_i,
    :existing_contacts  => params[:existing_contacts].to_i,
    :description        => params[:description],
    :asvab_new_exists   => params[:asvab_new_exists],
    :new_contacts       => params[:new_contacts].to_i,
    :attendees_event    => params[:attendees_event].to_i,
    :attendees_visit    => params[:attendees_visit].to_i,
    :attendees_conf     => params[:attendees_conf].to_i
  )
  params[:asvab_proctored] 		? report.update(:asvab_proctored => true) : report.update(:asvab_proctored => false)
  params[:rrc] 			          ? report.update(:rrc => true) 	          : report.update(:rrc => false)
  params[:sgm] 			          ? report.update(:sgm => true) 	          : report.update(:sgm => false)
  params[:eso] 			          ? report.update(:eso => true) 	          : report.update(:eso => false)
  params[:osm] 			          ? report.update(:osm => true) 	          : report.update(:osm => false)
  params[:mep_ess] 			      ? report.update(:mep_ess => true) 	      : report.update(:mep_ess => false)
  params[:outreach_event] 		? report.update(:outreach_event => true) 	: report.update(:outreach_event => false, :attendees_event => 0)
  params[:school_visit] 			? report.update(:school_visit => true) 	  : report.update(:school_visit => false, :attendees_visit => 0)
  params[:conference] 			  ? report.update(:conference => true) 	    : report.update(:conference => false, :attendees_conf => 0)

  if params[:contacts]
    params[:contacts].each do |contact|
      if contact.last['id']
        curr_contact = Contact.get(contact.last['id'])
        if contact.last['delete']
          curr_contact.destroy
        else
          if contact.last['name']
            contact.last['name'].strip!
            if contact.last['name'].length > 0
              curr_contact.update(:name => contact.last['name'], :source => contact.last['source'], :title => contact.last['title'], :location => contact.last['location'], :phone => contact.last['phone'], :email => contact.last['email'])
            end
          end
        end
      elsif contact.last['name']
        contact.last['name'].strip!
        if contact.last['name'].length > 0
          Contact.create(
            :user_id    => params[:user_id],
            :report_id  => report.id,
            :name       => contact.last['name'],
            :source     => contact.last['source'],
            :title      => contact.last['title'],
            :location   => contact.last['location'],
            :phone      => contact.last['phone'],
            :email      => contact.last['email']
          )
        end
      end
    end
  end

  session[:alert] = {
    style: 'alert-success',
    message: 'Report created successfully!'
  }
  redirect "/users/#{params[:user_id]}/reports"
end

get '/users/:user_id/reports/:id/delete/?' do  
  allowed [:educator_liaison, :admin, :regional]
  
  unless session[:admin] || params[:user_id].to_i == session[:user].to_i
  	session[:alert] = {
    	style: 'alert-error',
    	message: 'You do not have permission to delete this report.'
    }
  	redirect '/elp'
  end
  
  report = Report.get(params[:id])
  report.destroy
  session[:alert] = {
    style: 'alert-success',
    message: 'Report deleted successfully!'
  }
  redirect "/users/#{params[:user_id]}/reports"
end

get '/users/:user_id/reports/:id/?' do  
  access  = true	
  if session[:admin] || session[:ngb_customer]
  	access = true
  elsif session[:regional]
  	access = false unless User.get(params[:user_id]).region.id == User.get(session[:user]).region.id
  elsif session[:state_customer]
  	access = false unless User.get(params[:user_id]).state_id  == User.get(session[:user]).state_id
  elsif session[:user]
  	access = false unless params[:user_id].to_i == session[:user].to_i
  else
  	access = false
  end
  if access == false
  	session[:alert] = {
    	style: 'alert-error',
    	message: 'You do not have permission to see this report.'
    }
  	redirect '/elp'
  end
  
  @report = Report.get(params[:id])
  erb :'reports/form'
end

post '/users/:user_id/reports/:id/?' do  
  allowed [:user, :admin]
  
  unless session[:admin] || params[:user_id].to_i == session[:user].to_i
  	session[:alert] = {
    	style: 'alert-error',
    	message: 'You do not have permission to make changes.'
    }
  	redirect request.referrer
  end
  
  report = Report.get(params[:id])
  report.update(
    :date               => Chronic.parse("#{params[:date_year]}-#{params[:date_month]}-#{params[:date_day]}"),
    :title              => params[:title],
    :school             => params[:school],
    :zip                => params[:zip],
    :rrnco_name         => params[:rrnco_name],
    :host_educator      => params[:host_educator],
	  :rrnco_pres         => params[:rrnco_pres].to_i,
	  :elp_pres           => params[:elp_pres].to_i,
	  :rrnco_elp_pres			=> params[:rrnco_elp_pres].to_i,
	  :asvab              => params[:asvab].to_i,
	  :asvab_promo        => params[:asvab_promo].to_i,
    :cep                => params[:cep].to_i,
	  :ycsp               => params[:ycsp].to_i,
	  :cd                 => params[:cd].to_i,
	  :hop                => params[:hop].to_i,
	  :humvee             => params[:humvee].to_i,
	  :pie                => params[:pie].to_i,
	  :gfc                => params[:gfc].to_i,
    :hear               => params[:hear].to_i,
	  :other              => params[:other].to_i,
	  :other_activity     => params[:other_activity].to_i,
	  :team_leader        => params[:team_leader].to_i,
	  :rrnco              => params[:rrnco].to_i,
	  :trained            => params[:trained].to_i,
	  :existing_contacts  => params[:existing_contacts].to_i,
	  :description        => params[:description],
	  :asvab_new_exists   => params[:asvab_new_exists],
	  :new_contacts       => params[:new_contacts].to_i,
	  :attendees_event    => params[:attendees_event].to_i,
	  :attendees_visit    => params[:attendees_visit].to_i,
	  :attendees_conf     => params[:attendees_conf].to_i
  )
  params[:asvab_proctored] 		? report.update(:asvab_proctored => true) : report.update(:asvab_proctored => false)
  params[:rrc] 			          ? report.update(:rrc => true) 	          : report.update(:rrc => false)
  params[:sgm] 			          ? report.update(:sgm => true) 	          : report.update(:sgm => false)
  params[:eso] 			          ? report.update(:eso => true) 	          : report.update(:eso => false)
  params[:osm] 			          ? report.update(:osm => true) 	          : report.update(:osm => false)
  params[:mep_ess] 			      ? report.update(:mep_ess => true) 	      : report.update(:mep_ess => false)
  params[:outreach_event] 		? report.update(:outreach_event => true) 	: report.update(:outreach_event => false, :attendees_event => 0)
  params[:school_visit] 			? report.update(:school_visit => true) 	  : report.update(:school_visit => false, :attendees_visit => 0)
  params[:conference] 			  ? report.update(:conference => true) 	    : report.update(:conference => false, :attendees_conf => 0)

  if params[:contacts]
    params[:contacts].each do |contact|
      if contact.last['id']
        curr_contact = Contact.get(contact.last['id'])
        if contact.last['delete']
          curr_contact.destroy
        else
          if contact.last['name']
            contact.last['name'].strip!
            if contact.last['name'].length > 0
              curr_contact.update(:name => contact.last['name'], :source => contact.last['source'], :title => contact.last['title'], :location => contact.last['location'], :phone => contact.last['phone'], :email => contact.last['email'])
            end
          end
        end
      elsif contact.last['name']
        contact.last['name'].strip!
        if contact.last['name'].length > 0
          Contact.create(
            :user_id    => params[:user_id],
            :report_id  => params[:id],
            :name       => contact.last['name'],
            :source     => contact.last['source'],
            :title      => contact.last['title'],
            :location   => contact.last['location'],
            :phone      => contact.last['phone'],
            :email      => contact.last['email']
          )
        end
      end
    end
  end
  session[:alert] = {
    	style: 'alert-success',
    	message: 'Report updated successfully!'
    }
  redirect "/users/#{params[:user_id]}/reports"
end

class Report
	include DataMapper::Resource
	
	property   :id,         Serial
	property   :deleted_at, ParanoidDateTime
	timestamps :at

  property  :date,              Date,   :default => Chronic.parse('now')
  property  :activity,          String, :required => false
  property  :school,            String, :required => false
  property  :zip,               String, :required => false
  property  :title,             String, :required => false
                                
  property  :rrnco_pres,        Integer, :default => 0
  property  :elp_pres,          Integer, :default => 0
  property	:rrnco_elp_pres,		Integer, :default => 0
                                
  property  :asvab,             Integer, :default => 0
  property  :asvab_proctored,   Boolean, :default => false
  property  :asvab_promo,       Integer, :default => 0
  property  :cep,               Integer, :default => 0
  property  :ycsp,              Integer, :default => 0
  property  :cd,                Integer, :default => 0
  property  :hop,               Integer, :default => 0
  property  :humvee,            Integer, :default => 0
  property  :pie,               Integer, :default => 0
  property  :gfc,               Integer, :default => 0
  property  :hear,              Integer, :default => 0
  property  :other,             Integer, :default => 0
  property	:other_activity,		Integer, :default => 0
                                
  property  :rrc,       		    Boolean, :default => false
  property  :sgm,       		    Boolean, :default => false 		
  property  :team_leader,       Integer, :default => 0 
  property  :rrnco,             Integer, :default => 0 		
  property  :eso,               Boolean, :default => false		
  property  :osm,               Boolean, :default => false		
  
  property  :trained,           Integer, :default => 0

  property  :new_contacts,      Integer, :default => 0
  property  :existing_contacts, Integer, :default => 0     
  property  :outreach_event,    Boolean, :default => false
  property  :attendees_event,   Integer, :default => 0
  property  :school_visit,      Boolean, :default => false
  property  :attendees_visit,   Integer, :default => 0
  property  :conference,        Boolean, :default => false
  property  :attendees_conf,    Integer, :default => 0
  
  property  :asvab_new_exists,  String
  property  :mep_ess,           Boolean, :default => false

  property  :rrnco_name,        String,  :required => false
  property  :host_educator,     String,  :required => false
  
  property  :description,       Text,    :required => false
  
  belongs_to :user
  has n,     :contacts, :constraint => :destroy
  
  def pres_total
  	rrnco_pres + elp_pres + rrnco_elp_pres
  end

  def self.nc
  	State.first(:abbr => 'nc')
  end
  
end

class Contact
	include DataMapper::Resource

	property   :id,         Serial
	property   :deleted_at, ParanoidDateTime
	timestamps :at

  property  :name,        String, :required => false
  property  :source,      String
  property  :title,       String, :required => false
  property  :location,    String, :required => false
  property  :phone,       String, :required => false
  property  :email,       String, :required => false
  
  belongs_to :user
  belongs_to :report
end
