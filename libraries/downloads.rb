get "/downloads/?" do
  allowed [:user]
  @elp_downloads = Download.all(:order => :created_at.desc, :category => 'elp')
  @ctc_downloads = Download.all(:order => :created_at.desc, :category => 'ctc')
  erb :downloads
end

post  "/downloads/?"  do
  allowed [:admin, :regional]
  if params[:elp_file]
    File.open("public/files/#{params[:elp_file][:filename]}", 'wb') {|file| file.write(params[:elp_file][:tempfile].read)}
    Download.create(
    	:name 				=> params[:elp_name],
    	:description	=> params[:elp_description],
    	:filename			=> params[:elp_file][:filename],
    	:category     => 'elp'
    )
  end
  if params[:ctc_file]
    File.open("public/files/#{params[:ctc_file][:filename]}", 'wb') {|file| file.write(params[:ctc_file][:tempfile].read)}
    Download.create(
    	:name 				=> params[:ctc_name],
    	:description	=> params[:ctc_description],
    	:filename			=> params[:ctc_file][:filename],
    	:category     => 'ctc'
    )
  end
  redirect "/downloads"
end

get "/downloads/:id/delete/?" do
  allowed [:admin, :regional]
  download = Download.get(params[:id])
  File.delete "./public/files/#{download.filename}"
  download.destroy!
  redirect "/downloads"
end


class Download
	include DataMapper::Resource
	
	property   :id,         Serial
	property   :deleted_at, ParanoidDateTime
	timestamps :at

	property	:name,				String
	property	:description,	Text
	property	:filename,		String
	property  :category,    String, :default => 'elp'

end
