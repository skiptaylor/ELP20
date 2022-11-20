get '/travel/grid/?' do
  @elps = User.all(active: true, educator_liaison: true)
  erb :'travel/grid'
end

get '/travel/trip/?' do
  erb :'travel/trip', layout: false, locals: { trip: Trip.new, i: params[:i] }
end

get '/travel/status/?' do
  @new = ExpenseReport.all(status: 'New')
  @pm_rfi = ExpenseReport.all(status: 'PM RFI')
  @approved = ExpenseReport.all(status: 'NGB Approved')
  @ngb_rfi = ExpenseReport.all(status: 'NGB RFI')
  @non_forecasted = ExpenseReport.all(status: 'Non-forecasted Travel')
  @reimbursement_requested = ExpenseReport.all(status: 'Reimbursement Requested')
  @reimbursement_complete = ExpenseReport.all(status: 'Reimbursement Complete')
  @invoiceed = ExpenseReport.all(status: 'Invoiced')
  @cancelled = ExpenseReport.all(status: 'Cancelled')
  erb :'travel/edit'
end

get '/travel/:id/report/?' do
  allowed [:user, :admin]
  @expense_report = ExpenseReport.get(params[:id])
  erb :'travel/report'
end

get '/travel/?' do
  allowed [:user]
  @user = User.get(session[:user])

  status = params[:status] || 'NGB Approved'

  if params[:rc_start_date_day]
    @start_date = Chronic.parse("#{params[:rc_start_date_year]}-#{params[:rc_start_date_month]}-#{params[:rc_start_date_day]}")
  else
    @start_date = Chronic.parse('1 month ago')
  end

  if params[:rc_end_date_day]
    @end_date = Chronic.parse("#{params[:rc_end_date_year]}-#{params[:rc_end_date_month]}-#{params[:rc_end_date_day]}")
  else
    @end_date = Time.now
  end

  if status == 'All'
    @expense_reports = @user.expense_reports.all(:status.not => 'Cancelled', :status.not => 'Invoiced')
  else
    @expense_reports = @user.expense_reports.all(status: status)
  end

  if params[:status] == 'Invoiced'
    @expense_reports = @expense_reports.all(:start_date.gte => @start_date, :start_date.lte => @end_date)
  end

  erb :'travel/index'

end

get '/travel/new/?' do
  allowed [:user]
  @expense_report = ExpenseReport.new
  erb :'travel/edit'
end

post '/travel/new/?' do
  allowed [:user]
  @expense_report = ExpenseReport.create(
    :origin             => params[:origin],
    :destination        => params[:destination],
    :status             => params[:status],
    :reason_for_travel  => params[:reason_for_travel],
    :est_hotel          => params[:est_hotel].to_f,
    :hotel              => params[:hotel].to_f,
    :est_meals_and_misc => params[:est_meals_and_misc].to_f,
    :meals_and_misc     => params[:meals_and_misc].to_f,
    :est_mileage        => params[:est_mileage].to_f,
    :est_airline_ticket => params[:est_airline_ticket].to_f,
    :airline_ticket     => params[:airline_ticket].to_f,
    :est_parking        => params[:est_parking].to_f,
    :parking            => params[:parking].to_f,
    :est_car_rental     => params[:est_car_rental].to_f,
    :car_rental         => params[:car_rental].to_f,
    :est_misc           => params[:est_misc].to_f,
    :misc               => params[:misc].to_f,
    :est_transit        => params[:est_transit].to_f,
    :transit            => params[:transit].to_f,
    :commuter_mileage   => params[:commuter_mileage].to_i,
    :cash_advance       => params[:cash_advance].to_f,
    :user_id            => session[:user],
    :comments           => params[:comments],
    :invoice_number     => params[:invoice_number],
    :invoice_date       => params[:invoice_date],
    :approval_date      => params[:approval_date],
    :approval_initials  => params[:approval_initials],
    :check_date         => Chronic.parse("#{params[:check_date_year]}-#{params[:check_date_month]}-#{params[:check_date_day]}"),
    :check_number       => params[:check_number],
    :start_date         => Chronic.parse("#{params[:start_date_year]}-#{params[:start_date_month]}-#{params[:start_date_day]}"),
    :end_date           => Chronic.parse("#{params[:end_date_year]}-#{params[:end_date_month]}-#{params[:end_date_day]}")
  )

  params[:est_gsa_car] ? @expense_report.est_gsa_car = true : @expense_report.est_gsa_car = false
  params[:gsa_car] ? @expense_report.gsa_car = true : @expense_report.gsa_car = false

  params[:non_approved_trip] ? @expense_report.non_approved_trip = true : @expense_report.non_approved_trip = false

  @expense_report.status = 'Reimbursement Requested' if params[:submit_for_reimbursement]

  params[:trips].each do |t|
    @expense_report.trips.create(
      :travel_date  => Chronic.parse("#{t.last[:travel_date_year]}-#{t.last[:travel_date_month]}-#{t.last[:travel_date_day]}"),
      :reason_for_travel => t.last[:reason_for_travel],
      :departure_address => t.last[:departure_address],
      :arrival_address   => t.last[:arrival_address],
      :miles             => t.last[:miles].to_i
    )
  end

  redirect "/travel/#{@expense_report.id}/edit/?"
end

get '/travel/:id/delete/?' do
  allowed [:user, :admin]
  expense_report = ExpenseReport.get(params[:id])
  expense_report.destroy
  session[:alert] = {
    style: 'alert-success',
    message: 'Report deleted successfully!'
  }
  redirect "/travel/?"
end

get '/travel/:id/edit/?' do
  allowed [:user]
  @expense_report = ExpenseReport.get(params[:id])
  erb :'travel/edit'
end

post '/travel/:id/edit/?' do
  allowed [:user]
  @expense_report = ExpenseReport.get(params[:id])
  @expense_report.update(
    :origin             => params[:origin],
    :destination        => params[:destination],
    :status             => params[:status],
    :reason_for_travel  => params[:reason_for_travel],
    :est_hotel          => params[:est_hotel].to_f,
    :hotel              => params[:hotel].to_f,
    :est_meals_and_misc => params[:est_meals_and_misc].to_f,
    :meals_and_misc     => params[:meals_and_misc].to_f,
    :est_mileage        => params[:est_mileage].to_f,
    :est_airline_ticket => params[:est_airline_ticket].to_f,
    :airline_ticket     => params[:airline_ticket].to_f,
    :est_parking        => params[:est_parking].to_f,
    :parking            => params[:parking].to_f,
    :est_car_rental     => params[:est_car_rental].to_f,
    :car_rental         => params[:car_rental].to_f,
    :est_misc           => params[:est_misc].to_f,
    :misc               => params[:misc].to_f,
    :est_transit        => params[:est_transit].to_f,
    :transit            => params[:transit].to_f,
    :commuter_mileage   => params[:commuter_mileage].to_i,
    :cash_advance       => params[:cash_advance].to_f,
    :comments           => params[:comments],
    :invoice_number     => params[:invoice_number],
    :invoice_date       => params[:invoice_date],
    :check_date         => Chronic.parse("#{params[:check_date_year]}-#{params[:check_date_month]}-#{params[:check_date_day]}"),
    :check_number       => params[:check_number],

    :start_date         => Chronic.parse("#{params[:start_date_year]}-#{params[:start_date_month]}-#{params[:start_date_day]}"),
    :end_date           => Chronic.parse("#{params[:end_date_year]}-#{params[:end_date_month]}-#{params[:end_date_day]}")
  )

  params[:est_gsa_car] ? @expense_report.est_gsa_car = true : @expense_report.est_gsa_car = false
  params[:gsa_car] ? @expense_report.gsa_car = true : @expense_report.gsa_car = false

  params[:non_approved_trip] ? @expense_report.non_approved_trip = true : @expense_report.non_approved_trip = false

  @expense_report.status = 'Reimbursement Requested' if params[:submit_for_reimbursement]

  @expense_report.save

  @expense_report.trips.destroy
  params[:trips].each do |t|
    @expense_report.trips.first_or_create(
      :travel_date  => Chronic.parse("#{t.last[:travel_date_year]}-#{t.last[:travel_date_month]}-#{t.last[:travel_date_day]}"),
      :reason_for_travel => t.last[:reason_for_travel],
      :departure_address => t.last[:departure_address],
      :arrival_address   => t.last[:arrival_address],
      :miles             => t.last[:miles].to_i
    )
  end

  redirect "/travel/#{@expense_report.id}/edit/?"
end

get '/travel/approval/?' do
  allowed [:admin] unless backdoor(params[:secret_sign_in])
  @forcasted     = ExpenseReport.all(:status => 'New', non_approved_trip: false, :created_at.lte => Chronic.parse('Thursday at midnight'))
  @non_forcasted = ExpenseReport.all(:status => 'New', non_approved_trip: true,  :created_at.lte => Chronic.parse('Thursday at midnight'))
  erb :'travel/approval'
end

post '/travel/approval/?' do
  allowed [:admin] unless backdoor(params[:secret_sign_in])
  params[:approval_initials].downcase!
  params[:approval_initials].strip!

  unless params[:approval_initials].length > 0
    session[:alert] = {
      style: 'alert-error',
      message: 'You must enter your initials.'
    }

    redirect '/travel/approval'
  end

  params[:status].each do |s|
    ExpenseReport.get(s.first).update(
      status: s.last,
      approval_date: Time.now,
      approval_initials: params[:approval_initials]
    )
  end
  redirect '/travel/approval_thanks'
end

get '/travel/dashboard/?' do
  allowed [:admin]

  status = params[:status] || 'New'

  if params[:rc_start_date_day]
    @start_date = Chronic.parse("#{params[:rc_start_date_year]}-#{params[:rc_start_date_month]}-#{params[:rc_start_date_day]}")
  else
    @start_date = Chronic.parse('1 month ago')
  end

  if params[:rc_end_date_day]
    @end_date = Chronic.parse("#{params[:rc_end_date_year]}-#{params[:rc_end_date_month]}-#{params[:rc_end_date_day]}")
  else
    @end_date = Time.now
  end

  @expense_reports = ExpenseReport.all(status: status)

  if params[:status] == 'Reimbursement Complete'
    @expense_reports = @expense_reports.all(:check_date.gte => @start_date, :check_date.lte => @end_date)
  end

  if params[:status] == 'Invoiced' && params[:inv_num].strip.length > 0
    @expense_reports = @expense_reports.all(:invoice_number => params[:inv_num].strip)
  end

  @grand_total_estimated_cost = 0
  @grand_total_cost_of_trip = 0
  @grand_variance = 0

  @expense_reports.each do  |report|
    @grand_total_estimated_cost += report.total_estimated_cost
    @grand_total_cost_of_trip += report.total_cost_of_trip
    @grand_variance += report.variance
  end

  erb :'travel/dashboard'
end

post '/travel/dashboard/?' do
  allowed [:admin]

  if params[:reports_to_invoice]
    params[:reports_to_invoice].each do |i|
      report = ExpenseReport.get(i.first)
      report.invoice_number = params[:submit_invoiced].strip
      report.invoice_date = Chronic.parse("#{params[:invoice_date_year]}-#{params[:invoice_date_month]}-#{params[:invoice_date_day]}")
      report.status = "Invoiced"
      report.save
    end
  end

  # session[:flash] = params.inspect

  redirect('/travel/dashboard')
end

get '/travel/approved_on/?' do
  @approval_dates = ExpenseReport.all.map(&:approval_date).uniq
  params[:approved_on_date] ||= Time.now.to_s
  date = Chronic.parse(params[:approved_on_date])
  start_date = date - (60 * 60 * 12)
  end_date   = date + (60 * 60 * 12)
  @reports = ExpenseReport.all(:approval_date.gte => start_date, :approval_date.lte => end_date)
  erb :'travel/approved_on'
end


class ExpenseReport
	include DataMapper::Resource

	timestamps :at, :on
	property   :deleted_at, ParanoidDateTime
	property 	 :id, 				Serial

  belongs_to :user,  :required => false
  has n, :trips, :constraint => :destroy

  property :non_approved_trip, Boolean, default: false

  property :start_date, Date, :default => Chronic.parse('now')
  property :end_date,   Date, :default => Chronic.parse('now')

  property :origin,             String, default: ""
  property :destination,        String, default: ""
  property :status,             String, default: ""
  property :reason_for_travel,  Text,   default: ""

  property :est_hotel,          Float,    default: 0
  property :hotel,              Float,    default: 0
  property :est_meals_and_misc, Float,    default: 0
  property :meals_and_misc,     Float,    default: 0
  property :est_mileage,        Float,    default: 0
  property :est_airline_ticket, Float,    default: 0
  property :airline_ticket,     Float,    default: 0
  property :est_parking,        Float,    default: 0
  property :parking,            Float,    default: 0
  property :est_car_rental,     Float,    default: 0
  property :car_rental,         Float,    default: 0
  property :est_misc,           Float,    default: 0
  property :misc,               Float,    default: 0
  property :est_transit,        Float,    default: 0
  property :transit,            Float,    default: 0
  property :comments,           Text,     default: ""

  property :approval_date,      DateTime, :default => Chronic.parse('now')
  property :approval_initials,  String,   default: ""

  property :invoice_number,     String,   default: ""
  property :invoice_date,       DateTime, :default => Chronic.parse('now')

  property :est_gsa_car,        Boolean, default: false
  property :gsa_car,            Boolean, default: false

  property :commuter_mileage,   Integer, default: 0

  property :cash_advance,       Float, default: 0

  property :check_date,         DateTime, :default => Chronic.parse('now')
  property :check_number,       String,   default: ""

  def total_travel_days
    if self.end_date && self.start_date
      return (self.end_date - self.start_date).to_i + 1
    else
      return 0
    end
  end

  def est_rate_per_day
    (self.est_hotel + self.est_meals_and_misc).to_f
  end

  def est_trip_per_diem
    if self.total_travel_days <= 1
      return (0.75 * self.est_meals_and_misc).to_f
    elsif self.total_travel_days == 2
      return (self.est_hotel + (1.5 * self.est_meals_and_misc)).to_f
    elsif self.total_travel_days() >= 3
      return ((self.total_travel_days - 2) * self.est_rate_per_day + self.est_hotel + (1.5 * self.est_meals_and_misc)).to_f
    else
      return 0
    end
  end

  def total_estimated_cost
    if self.start_date && (self.start_date < Chronic.parse('Jan 14 2014 0:00').to_date)
      (self.est_trip_per_diem + (self.est_mileage * 0.565) + self.est_airline_ticket + self.est_parking + self.est_transit + self.est_car_rental + self.est_misc).to_f
    else
      (self.est_trip_per_diem + (self.est_mileage * 0.56) + self.est_airline_ticket + self.est_parking + self.est_transit + self.est_car_rental + self.est_misc).to_f
    end
  end

  def total_pov_mileage
    total_miles = 0
    self.trips.each do |trip|
      total_miles = total_miles + trip.miles
    end
    total_miles
  end

  def mileage_reimbursement
    if self.start_date && (self.start_date < Chronic.parse('Jan 14 2014 0:00').to_date)
      (((self.total_pov_mileage - self.commuter_mileage) * 0.565) + 0.001)
    else
      ((self.total_pov_mileage - self.commuter_mileage) * 0.56)
    end
  end

  def due_employee
    # Is this the correct calculation?
    (self.mileage_reimbursement + self.car_rental + self.hotel + self.parking + self.meals_and_misc + self.transit + self.misc).to_f
  end

  def ctc_prepaid
    self.airline_ticket
  end

  def total_cost_of_trip
    (self.due_employee + self.ctc_prepaid).to_f
  end

  def total_reembursement_due
    (self.due_employee - self.cash_advance).to_f
  end

  def mileage_difference
    (self.total_pov_mileage - self.commuter_mileage)
  end

  def per_diem_reembursement_explanation
    if (self.meals_and_misc.to_f + self.hotel.to_f) <= self.est_trip_per_diem.to_f
      return '<span class="text-success">Okay - Your Meals and Hotel costs are within the requested rate.</span>'
    else
      return '<span class="text-error">Warning - Your Meals and Hotel total exceeds the requested rate.</span>'
    end
  end

  def self.el_by_dates(el_id, start_date, end_date)
    all(user_id: el_id, :start_date.gte => start_date, :start_date.lte => end_date)
  end

  def variance
    self.total_cost_of_trip - self.total_estimated_cost
  end

  def self.total_reembursement_due_for_reports(reports)
    total = 0.0
    reports.each do |r|
      total = total + r.total_reembursement_due
    end
    total
  end

  def cost_items_list
    list = []

    list << 'POV'    if self.est_mileage > 0
    list << 'Hotel'  if self.est_hotel > 0
    list << 'Meals'  if self.est_meals_and_misc > 0
    list << 'Car'    if self.est_car_rental > 0
    list << 'Park'   if self.est_parking > 0
    list << 'Taxi'   if self.est_transit > 0
    list << 'Flight' if self.est_airline_ticket > 0
    list << 'Misc.'  if self.est_misc > 0

    list.join(', ')
  end

  def cost_items_list_nf
    list = []

    list << 'POV'    if self.total_pov_mileage > 0
    list << 'Hotel'  if self.hotel > 0
    list << 'Meals'  if self.meals_and_misc > 0
    list << 'Car'    if self.car_rental > 0
    list << 'Park'   if self.parking > 0
    list << 'Taxi'   if self.transit > 0
    list << 'Flight' if self.airline_ticket > 0
    list << 'Misc.'  if self.misc > 0

    list.join(', ')
  end

end
