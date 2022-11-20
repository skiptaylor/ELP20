southeast = Region.create(:name => 'Southeast')
northeast = Region.create(:name => 'Northeast')
north     = Region.create(:name => 'North')
midwest   = Region.create(:name => 'Midwest')
west      = Region.create(:name => 'West')

al = State.create(:name => 'Alabama',        :abbr => 'AL', :region_id => southeast.id)
ga = State.create(:name => 'Georgia',        :abbr => 'GA', :region_id => southeast.id)
ky = State.create(:name => 'Kentucky',       :abbr => 'KY', :region_id => southeast.id)
ms = State.create(:name => 'Mississippi',    :abbr => 'MS', :region_id => southeast.id)
nc = State.create(:name => 'North Carolina', :abbr => 'NC', :region_id => southeast.id)
sc = State.create(:name => 'South Carolina', :abbr => 'SC', :region_id => southeast.id)

ny = State.create(:name => 'New York',       :abbr => 'NY', :region_id => northeast.id)
ma = State.create(:name => 'Massachusetts',  :abbr => 'MA', :region_id => northeast.id)
md = State.create(:name => 'Maryland',       :abbr => 'MD', :region_id => northeast.id)
nj = State.create(:name => 'New Jersey',     :abbr => 'NJ', :region_id => northeast.id)
pa = State.create(:name => 'Pennsylvania',   :abbr => 'PA', :region_id => northeast.id)
va = State.create(:name => 'Virginia',       :abbr => 'VA', :region_id => northeast.id)

mn = State.create(:name => 'Minnesota',      :abbr => 'MN', :region_id => north.id)
mi = State.create(:name => 'Michigan',       :abbr => 'MI', :region_id => north.id)
oh = State.create(:name => 'Ohio',           :abbr => 'OH', :region_id => north.id)
wi = State.create(:name => 'Wisconsin',      :abbr => 'WI', :region_id => north.id)
ia = State.create(:name => 'Iowa',           :abbr => 'IA', :region_id => north.id)

ar = State.create(:name => 'Arkansas',       :abbr => 'AR', :region_id => midwest.id)
il = State.create(:name => 'Illinois',       :abbr => 'IL', :region_id => midwest.id)
la = State.create(:name => 'Louisiana',      :abbr => 'LA', :region_id => midwest.id)
mo = State.create(:name => 'Missouri',       :abbr => 'MO', :region_id => midwest.id)
ok = State.create(:name => 'Oklahoma',       :abbr => 'OK', :region_id => midwest.id)

ca = State.create(:name => 'California',     :abbr => 'CA', :region_id => west.id)
ore = State.create(:name => 'Oregon',         :abbr => 'OR', :region_id => west.id)
nm = State.create(:name => 'New Mexico',     :abbr => 'NM', :region_id => west.id)
co = State.create(:name => 'Colorado',       :abbr => 'CO', :region_id => west.id)



skip = User.create(
  :email => 'skip@clear.net',
  :password => 'revolver',
  :first_name => 'Skip',
  :last_name => 'Taylor',
  :title => 'Administrator',
  :state_id => ga.id,
  :admin => true
)

matt = User.create(
  :email => 'mmorgan@careertrain.com',
  :password => 'beansong',
  :first_name => 'Matthew',
  :last_name => 'Morgan',
  :title => 'Administrator',
  :state_id => ga.id,
  :admin => true
)

jimmy = User.create(
  :email => 'jshafe@careertrain.com',
  :password => 'cdguard97',
  :first_name => 'Jimmy',
  :last_name => 'Shafe',
  :title => 'Administrator',
  :state_id => ga.id,
  :admin => true
)

dave = User.create(
  :email => 'dotto@careertrain.com',
  :password => 'cdguard98',
  :first_name => 'Dave',
  :last_name => 'Otto',
  :title => 'Administrator',
  :state_id => ga.id,
  :admin => true
)

tony = User.create(
  :email => 'tdesena@careertrain.com',
  :password => 'tdesena2001',
  :first_name => 'Tony',
  :last_name => 'DeSena',
  :title => 'Regional-ELP',
  :state_id => ga.id,
  :admin => false
)

mike = User.create(
  :email => 'mbellos@careertrain.com',
  :password => 'mbellos3002',
  :first_name => 'Mike',
  :last_name => 'Bellos',
  :title => 'Regional-ELP',
  :state_id => ga.id,
  :admin => false
)

stanley = User.create(
  :email => 'scox@careertrain.com',
  :password => 'scox4003',
  :first_name => 'Stanley',
  :last_name => 'Cox',
  :title => 'Regional-ELP',
  :state_id => ga.id,
  :admin => false
)

jim = User.create(
  :email => 'jmajors@careertrain.com',
  :password => 'jmajors5004',
  :first_name => 'Jim',
  :last_name => 'Majors',
  :title => 'Regional-ELP',
  :state_id => ga.id,
  :admin => false
)

jackie = User.create(
  :email => 'jdodge@careertrain.com',
  :password => 'jdodge6005',
  :first_name => 'Jackie',
  :last_name => 'Dodge',
  :title => 'NGB Customer',
  :state_id => ga.id,
  :admin => false
)

#beta_tester = User.create(
#	:email 			=> 'johnsmith@gallifrey.org',
#	:password 	=> 'tardis',
#	:first_name => 'John',
#	:last_name 	=> 'Smith',
#	:title 			=> 'Doctor',
#  :state_id => co.id
#)
#
#tester = User.create(
#	:email 			=> 'alfred@wmw.com',
#	:password 	=> 'what',
#	:first_name => 'Alfred',
#	:last_name 	=> 'Newnam',
#	:title 			=> 'Character',
#  :state_id => nj.id
#)
#
#Report.create(
#  :user_id => skip.id,
#  :date => Chronic.parse('today'),
#  :title => 'Educator',
#  :school => 'This school',
#  :zip => 30043,
#)
#
#Report.create(
#  :user_id => tester.id,
#  :date => Chronic.parse('22 days ago'),
#  :title => 'Educator',
#  :school => 'This Old School',
#  :zip => 30053,
#)
#Report.create(
#  :user_id => tester.id,
#  :date => Chronic.parse('11 days ago'),
#  :title => 'Educator',
#  :school => 'That Old School',
#  :zip => 30063,
#)
#Report.create(
#  :user_id => tester.id,
#  :date => Chronic.parse('1 days ago'),
#  :title => 'Educator',
#  :school => 'My Old School',
#  :zip => 30073,
#)
#Report.create(
#  :user_id => tester.id,
#  :date => Chronic.parse('9 days ago'),
#  :title => 'Educator',
#  :school => 'Your Old School',
#  :zip => 30083,
#)
#
#Report.create(
#  :user_id => matt.id,
#  :date => Chronic.parse('1 days ago'),
#  :title => 'Educator',
#  :school => 'Your High School',
#  :zip => 30276,
#)
#
#Report.create(
#  :user_id => tester.id,
#  :date => Chronic.parse('14 days ago'),
#  :title => 'Educator',
#  :school => 'That Old School',
#  :zip => 30093,
#)
#
#Report.create(
#  :user_id => beta_tester.id,
#  :date => Chronic.parse('22 days ago'),
#  :title => 'Educator',
#  :school => 'This Old School',
#  :zip => 30053,
#)
#Report.create(
#  :user_id => beta_tester.id,
#  :date => Chronic.parse('11 days ago'),
#  :title => 'Educator',
#  :school => 'That Old School',
#  :zip => 30063,
#)
#Report.create(
#  :user_id => beta_tester.id,
#  :date => Chronic.parse('1 days ago'),
#  :title => 'Educator',
#  :school => 'My Old School',
#  :zip => 30073,
#)
#Report.create(
#  :user_id => beta_tester.id,
#  :date => Chronic.parse('9 days ago'),
#  :title => 'Educator',
#  :school => 'Your Old School',
#  :zip => 30083,
#)
#Report.create(
#  :user_id => beta_tester.id,
#  :date => Chronic.parse('14 days ago'),
#  :title => 'Educator',
#  :school => 'That Old School',
#  :zip => 30093,
#)
#
#Report.create(
#  :user_id => skip.id,
#  :date => Chronic.parse('yesterday'),
#  :title => 'Educator',
#  :school => 'This school',
#  :zip => 30043,
#)
#
#Report.create(
#  :user_id => skip.id,
#  :date => Chronic.parse('2 days ago'),
#  :title => 'Educator',
#  :school => 'This school',
#  :zip => 30043,
#)
#
#Report.create(
#  :user_id => skip.id,
#  :date => Chronic.parse('2 days ago'),
#  :title => 'Educator',
#  :school => 'This school',
#  :zip => 30043,
#)
#
#Report.create(
#  :user_id => skip.id,
#  :date => Chronic.parse('3 days ago'),
#  :title => 'Educator',
#  :school => 'This school',
#  :zip => 30043,
#)
#
#Report.create(
#  :user_id => skip.id,
#  :date => Chronic.parse('4 days ago'),
#  :title => 'Educator',
#  :school => 'This school',
#  :zip => 30043,
#)
#
#Report.create(
#  :user_id => skip.id,
#  :date => Chronic.parse('7 days ago'),
#  :title => 'Educator',
#  :school => 'This school',
#  :zip => 30043,
#)
#
#Report.create(
#  :user_id => skip.id,
#  :date => Chronic.parse('5 days ago'),
#  :title => 'Educator',
#  :school => 'This school',
#  :zip => 30043,
#)
#
#Report.create(
#  :user_id => skip.id,
#  :date => Chronic.parse('5 days ago'),
#  :title => 'Educator',
#  :school => 'This school',
#  :zip => 30043,
#)
#
#Report.create(
#  :user_id => skip.id,
#  :date => Chronic.parse('6 days ago'),
#  :title => 'Educator',
#  :school => 'This school',
#  :zip => 30043,
#)
#
#Report.create(
#  :user_id => skip.id,
#  :date => Chronic.parse('8 days ago'),
#  :title => 'Educator',
#  :school => 'This school',
#  :zip => 30043,
#)
#
#Report.create(
#  :user_id => skip.id,
#  :date => Chronic.parse('9 days ago'),
#  :title => 'Educator',
#  :school => 'This school',
#  :zip => 30043,
#)
#
#Report.create(
#  :user_id => skip.id,
#  :date => Chronic.parse('10 days ago'),
#  :title => 'Educator',
#  :school => 'This school',
#  :zip => 30043,
#)
#
#Report.create(
#  :user_id => skip.id,
#  :date => Chronic.parse('11 days ago'),
#  :title => 'Educator',
#  :school => 'This school',
#  :zip => 30043,
#)
#
#Report.create(
#  :user_id => skip.id,
#  :date => Chronic.parse('12 days ago'),
#  :title => 'Educator',
#  :school => 'This school',
#  :zip => 30043,
#)
#
#Report.create(
#  :user_id => skip.id,
#  :date => Chronic.parse('12 days ago'),
#  :title => 'Educator',
#  :school => 'This school',
#  :zip => 30043,
#)
#
#Report.create(
#  :user_id => skip.id,
#  :date => Chronic.parse('13 days ago'),
#  :title => 'Educator',
#  :school => 'This school',
#  :zip => 30043,
#)
#
#Report.create(
#  :user_id => skip.id,
#  :date => Chronic.parse('14 days ago'),
#  :title => 'Educator',
#  :school => 'This school',
#  :zip => 30043,
#)
#
#Report.create(
#  :user_id => skip.id,
#  :date => Chronic.parse('15 days ago'),
#  :title => 'Educator',
#  :school => 'This school',
#  :zip => 30043,
#)
#
#Report.create(
#  :user_id => skip.id,
#  :date => Chronic.parse('16 days ago'),
#  :title => 'Educator',
#  :school => 'This school',
#  :zip => 30043,
#)