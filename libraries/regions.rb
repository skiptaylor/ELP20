class Region
	include DataMapper::Resource

	property    :id,          Serial
	property    :deleted_at,  ParanoidDateTime
	timestamps  :at

  property    :name,        String, :required => false
  
  has n,      :states
  has n, :users, {:through => :states}
  
end
