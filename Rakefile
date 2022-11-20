# Import the application to run rake tasks against

  require 'bundler'
  Bundler.require
 	require './config/settings'
  Dir.glob File.dirname(__FILE__) + '/libraries/*.rb', &method(:require)
  DataMapper.finalize
  DataMapper.setup(:default, "sqlite://#{Dir.pwd}/data/data.sqlite3")

  task :setup => ['db:migrate', 'db:seed']
  task :build => ['setup', 'rackup']
  
  task :rackup do
    exec 'rackup'
  end


# Non-destructive

  desc 'Auto upgrades the database'
  task :upgrade do
    DataMapper.auto_upgrade!
  end

# Destructive

  desc 'Auto migrates the database'
  task :migrate do
    DataMapper.auto_migrate!
  end

# Enters seed data

  desc 'Seeds the database'
  task :seed do
    require "#{Dir.pwd}/data/seeds.rb"
  end

# For programmatically altering the data

  desc 'Ruby script to alter data'
  task :transmogrify do
    require "#{Dir.pwd}/data/transmogrify.rb"
  end

  
  desc 'Starts an IRB session with the app loaded'
  task :irb do
    require 'irb'
    ARGV.clear # No idea why IRB looks for this?!?
    IRB.start
  end
  
  desc 'Loads the application into a development server'
	task(:server) { exec 'ruby chassis.rb' }
