# Manage gems with Bundler (Gemfile and Gemfile.lock)

  require 'bundler'
  Bundler.require
  
  require 'sinatra/namespace'
  require 'cgi'
  require 'net/http'


# Include configurations

  require './config/settings'
  # require './config/accounts'
  
  
  # helpers Rack::Recaptcha::Helpers


# Include Ruby libraries

  Dir.glob File.dirname(__FILE__) + '/libraries/*.rb', &method(:require)
  
  get '/*/?' do
	  erb :"#{params[:splat].first}"
  end
  
  configure :production do
    error(404) { erb :error, layout: false, locals: { code: '404', message: 'Not Found'             } }
    error(400) { erb :error, layout: false, locals: { code: '400', message: 'Bad Request'           } }
    error(401) { erb :error, layout: false, locals: { code: '401', message: 'Unauthorized'          } }
    error(403) { erb :error, layout: false, locals: { code: '403', message: 'Forbidden'             } }
    error(408) { erb :error, layout: false, locals: { code: '408', message: 'Request Timeout'       } }
    error(500) { erb :error, layout: false, locals: { code: '500', message: 'Internal Server Error' } }
    error(502) { erb :error, layout: false, locals: { code: '502', message: 'Bad Gateway'           } }
  end

# Include database config

  require './config/databases'

