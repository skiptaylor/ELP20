post '/reports/summary_nc/:month/:year/?' do
  redirect "/reports/summary_nc/#{params[:new_month]}/#{params[:new_year]}"
end

get '/reports/summary_nc/:month/:year/?' do  
	allowed [:admin, :regional]
  
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
      
  @reports = User.all(:nc_el => 't').reports + User.first(:email => 'cfrazer@careertrain.com').reports
  
  @reports = @reports.all(:date.lt => end_date, :date.gte => start_date)
    
  erb :'reports/summary_nc'
end

post '/reports/custom_summary_nc/:start_date/:end_date/?' do
	new_start_date = "#{params[:start_year]}-#{params[:start_month]}-#{params[:start_day]}"
	new_end_date 	 = "#{params[:end_year]}-#{params[:end_month]}-#{params[:end_day]}"
 	redirect "/reports/custom_summary_nc/#{new_start_date}/#{new_end_date}"
end

get '/reports/custom_summary_nc/:start_date/:end_date/?' do
	allowed [:admin, :regional]
	
	if params[:state] && params[:state] != 'all'
		state_id = State.first(:abbr => params[:state]).id
	end

  @reports = User.all(:nc_el => 't').reports + User.first(:email => 'cfrazer@careertrain.com').reports
  
  @reports = @reports.all(:date.lte => Chronic.parse(params[:end_date]), :date.gte => Chronic.parse(params[:start_date]))
  erb :'reports/summary_nc'
end
