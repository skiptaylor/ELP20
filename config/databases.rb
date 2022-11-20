# This should be split up into environments before going live

# Finalize data models and connect to database

  DataMapper.finalize
  configure :development do
  	DataMapper::Logger.new $stdout, :debug
  	DataMapper.setup :default, 'postgres://localhost/elp_4testing_db'
  end

  configure :production do
  	DataMapper.setup(:default, ENV['DATABASE_URL'] || 'postgres://localhost/mydb')
  end
