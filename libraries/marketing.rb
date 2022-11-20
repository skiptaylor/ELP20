get '/contact/?' do
  erb :contact
end

get '/corporate/?' do
  erb :corporate
end

get '/elp-contacts/?' do
  @users = User.all(educator_liaison: true, active: true)
  erb :'elp-contacts'
end

get '/gsa/?' do
  erb :gsa
end

get '/partners/?' do
  erb :partners
end

get '/personnel/?' do
  erb :personnel
end

get '/publications/?' do
  erb :publications
end

get '/training/?' do
  erb :training
end