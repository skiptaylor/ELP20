get '/home/?' do
  erb :'sign-in'
end

# get '/elp/?' do
#   erb :'elp'
# end


# post '/arng/?' do

  # halt(503) if params[:town] != ""
  
  
    
#   if params[:name] == "" || params[:school] == "" || params[:email] == "" || params[:phone] == "" || params[:city] == ""
#     session[:alert] = {
#       style: 'alert-error',
#       message: "You must complete all required fields."
#     }
#     redirect request.referrer
#   else
#
#
#     if params[:email_name] == ""
#
#
#     to_elps = []
#     User.all(educator_liaison: true, state_id: params[:state], :active => true).each { |u| to_elps << u.email }
#
#     to_elps << 'JMusumeche@careertrain.com'
#     to_elps << 'mmorgan@careertrain.com'
#     to_elps << 'skiptaylor101@gmail.com'
#
#     Pony.mail(
#       to: to_elps,
#       from: 'info@careertrain.com',
#       subject: 'ARNG School Programs Inquiry',
#       body: "
#
#     Please contact the educator below who has requested more information about the listed National Guard school programs.
#
#
#     Name: #{params[:name]}
#
#     School: #{params[:school]}
#
#     Email: #{params[:email]}
#
#     Phone: #{params[:phone]}
#
#     City: #{params[:city]}
#
#     State: #{State.get(params[:state]).abbr}
#
#     Zip: #{params[:zip]}
#
#
#     Program of interest:
#
#     #{params[:hear]}
#
#     #{params[:youcan]}
#
#     #{params[:guardfit]}
#
#     #{params[:cd2]}
#
#     #{params[:humvee]}
#
#     #{params[:hop]}
#
#
#     "
#       )
#
#     redirect '/thank-you'
#   end
# end
# end
#
# get '/thank-you/?' do
#   erb :'arng/thank-you'
# end
