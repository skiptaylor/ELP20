set :vcard_config, {
  :db_model   => 'contact',
  :first_name => 'contact.name',
  :last_name  => 'contact.name',
  :title      => 'contact.title',
  :org        => 'contact.location',
  :phone      => 'contact.phone',
  :email      => 'contact.email'
}

get '/vcard/all/?' do
  response.headers['Content-Type'] = 'text/csv; charset=utf-8'
  response.headers['Content-Disposition'] = "attachment; filename=contacts.csv"
  
  cards = ''

  cards = CSV.generate do |csv|
    csv << ['Contact Name', 'Title', 'Location', 'Source', 'Phone', 'Email', 'Zip Code', 'State', 'EL Name', 'Report Date']
    Contact.all.each do |c|
			zip = ''
			date = ''
			if c.report_id
				if c.report.zip
					zip = c.report.zip
				end
				if c.report.date
					date = format_day(c.report.date)
				end
			end
      csv << [c.name, c.title, c.location, c.source, c.phone, c.email, zip, c.user.state.abbr, "#{c.user.first_name} #{c.user.last_name}", date]
    end
  end
  
  if cards.length > 0
    return cards
  else
    return false
  end
end

get '/vcard/user/:id/?' do
  response.headers['Content-Type'] = 'text/csv; charset=utf-8'
  response.headers['Content-Disposition'] = "attachment; filename=contacts.csv"
  
  cards = ''

  cards = CSV.generate do |csv|
    csv << ['Name', 'Title', 'location', 'Source', 'Phone', 'Email']
    User.get(params[:id]).reports.contacts.each do |c|
      csv << [c.name, c.title, c.location, c.source, c.phone, c.email]
    end
  end
  
  if cards.length > 0
    return cards
  else
    return false
  end
end

get '/vcard/:id/?' do
  contact = Contact.get(params[:id])
  response.headers['Content-Type'] = 'text/x-vcard; charset=utf-8'
  response.headers['Content-Disposition'] = "attachment; filename=#{contact.name}.vcf"
  Card.contact(params[:id])
end

module Card
  
  def self.contact(id)
    contact = Contact.get(id)
    output = ''

    card = Vcard::Vcard::Maker.make2 do |maker|

  		maker.add_name do |name|
  	  	name.given  = eval('contact.name').split(' ').first.to_s
  			name.family = eval('contact.name').split(' ').last.to_s
  		end

  		maker.title = eval('contact.title').to_s
  		maker.org = eval('contact.location').to_s

  		phone = eval('contact.phone').to_s
  		email = eval('contact.email').to_s

  		phone = 'N/A' if phone == ''
  		email = 'N/A' if email == ''

  		maker.add_tel(phone)    {|t| t.location = 'work'; t.preferred = true }
  		maker.add_email(email)  {|e| e.location = 'work'; e.preferred = 'yes'}

    end

    output << card.to_s

    output
  end
  
end