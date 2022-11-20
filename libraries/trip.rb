get '/travel/:id/trip/?' do
  allowed [:user]
  expense_report = ExpenseReport.get(params[:id])
  @trip = Trip.get(params[:id])
  erb :'travel/trip'
end

get '/travel/:expense_report_id/trips/new/?' do
  allowed [:user]
  @expense_report = ExpenseReport.get(params[:expense_report_id])
  @trip = @expense_report.trip.new
  erb :'travel/trip'
end

post '/travel/:expense_report_id/trips/new/?' do
  allowed [:user]
  trip = Trip.create(
    :travel_date        => params[:travel_date],
    :reason_for_travel  => params[:reason_for_travel],
    :departure_address  => params[:departure_address],
    :arrival_address    => params[:arrival_address],
    :miles              => params[:miles],
  )
  redirect "/travel/#{params[:expense_report_id]}/edit"
end

get '/travel/<%= @expense_report.id %>/trips/<%= trip.id %>/edit/?' do
  allowed [:user]
  @trip = Trip.new
  erb :'travel/<%= @expense_report.id %>/trips/<%= trip.id %>/trip/?'
end

post '/travel/#{params[:expense_report.id]/trips/:id/edit/?' do
  allowed [:user]
  @trip = Trip.create(
    :travel_date        => params[:travel_date],
    :reason_for_travel  => params[:reason_for_travel],
    :departure_address  => params[:departure_address],
    :arrival_address    => params[:arrival_address],
    :miles              => params[:miles],
  )
  redirect "/travel/:id/trips/#{params[:trip.id]}/edit"
end

class Trip
	include DataMapper::Resource

	timestamps :at, :on
	property   :deleted_at, ParanoidDateTime
	property 	 :id, 				Serial

  belongs_to :expense_report

  property :travel_date,        Date, :default => Chronic.parse('now')
  property :reason_for_travel,  Text, default: ""
  property :departure_address,  Text, default: ""
  property :arrival_address,    Text, default: ""
  property :miles,              Integer, default: 0

end
