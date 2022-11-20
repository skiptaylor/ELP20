# Hot reloading

	require 'sinatra/reloader' if development?

# Enable sessions

  configure(:development) { set :domain, 'localhost' }
  configure(:production)  { set :domain, 'elpactivities.com' }

  use Rack::Session::Cookie,  :key => 'my_app_key',
#                               :domain => settings.domain,
                              :path => '/',
                              :expire_after => 864000,
                              :secret => 'secret123'

                              
# Render .html with embedded Ruby

  Tilt.register Tilt::ERBTemplate, 'html'


#	Redirect root url

  get '/?' do
      redirect '/sign-in'
  end

# Monthly averages

  set :monthly_avg, {
    :rrnco_pres         => 0,
    :elp_pres           => 8,
    :asvab              => 0,
    :ycsp               => 0,
    :cd                 => 0,
    :hop                => 0,
    :humvee             => 0,
    :pie                => 0,
    :gfc                => 0,
    :hear               => 0,
    :other              => 0,
    :total              => 0,
    :rrc                => 1,
    :sgm                => 1,
    :team_leader        => 4,
    :rrnco              => 0,
    :eso                => 1,
    :osm                => 0,
    :trained            => 0,
    :new_contacts       => 20,
    :existing_contacts  => 10,
    :attendees_visit    => 0,
    :attendees_event    => 0,
    :attendees_conf     => 0,
    :asvab_new_exists   => 1,
    :mep_ess            => 2
  }
