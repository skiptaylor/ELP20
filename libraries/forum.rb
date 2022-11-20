get '/forum/instructions' do
  allowed [:user]
  erb :'forum/instructions'
end

get '/forum/sections/:name/?' do
	allowed [:user]
	@topics = Topic.all(:section => params[:name], :order => :updated_at.desc)
  erb :'forum/section'
end

get '/forum/topic/:id/?' do
	allowed [:user]
  @topic = Topic.get(params[:id])
  @comments = @topic.comments(:order => :created_at.asc)
  erb :'forum/topic'
end

post '/forum/topic/?' do
	allowed [:user]
  topic = Topic.create(
  	:title 				=> params[:title],
		:description	=> params[:description],
		:section			=> params[:section],
		:user_id 			=> session[:user]
  )
  redirect "/forum/topic/#{topic.id}"
end

post '/forum/topic/:id/comment/?' do
  allowed [:user]
  Comment.create(
  	:body 		=> params[:body],
  	:topic_id => params[:id],
  	:user_id	=> session[:user]
  )
  topic = Topic.get(params[:id])
  topic.update(:updated_at => Time.now)
  redirect "/forum/topic/#{params[:id]}"
end

get '/forum/topic/:id/edit/?' do
	allowed [:user]
	@topic = Topic.get(params[:id])
	unless session[:admin] || @topic.user_id == session[:user]
		session[:alert] = {
    	style: 'alert-error',
    	message: "Sorry, you can't do that."
    }
		redirect request.referrer
	end
	erb :'forum/edit_topic'
end

post '/forum/topic/:id/edit/?' do
	allowed [:user]
	@topic = Topic.get(params[:id])
	unless session[:admin] || @topic.user_id == session[:user]
		session[:alert] = {
    	style: 'alert-error',
    	message: "Sorry, you can't do that."
    }
		redirect request.referrer
	end
	@topic.update(:title => params[:title], :description => params[:description])
	session[:alert] = {
    style: 'alert-success',
    message: "Topic updated."
  }
	redirect "/forum/topic/#{@topic.id}"
end

get '/forum/comment/:id/edit/?' do
	allowed [:user]
	@comment = Comment.get(params[:id])
	unless session[:admin] || @comment.user_id == session[:user]
		session[:alert] = {
    	style: 'alert-error',
    	message: "Sorry, you can't do that."
    }
		redirect request.referrer
	end
	erb :'forum/edit_comment'
end

post '/forum/comment/:id/edit/?' do
	allowed [:user]
	@comment = Comment.get(params[:id])
	@comment = Comment.get(params[:id])
	unless session[:admin] || @comment.user_id == session[:user]
		session[:alert] = {
    	style: 'alert-error',
    	message: "Sorry, you can't do that."
    }
		redirect request.referrer
	end
	@comment.update(:body => params[:body])
	session[:alert] = {
  	style: 'alert-success',
  	message: "Comment updated."
  }
	redirect "/forum/topic/#{@comment.topic.id}"
end

get '/forum/topic/:id/delete/?' do
	allowed [:user]
  topic = Topic.get(params[:id])
  unless session[:admin] || topic.user_id == session[:user]
  	session[:alert] = {
    	style: 'alert-error',
    	message: "Sorry, you can't do that."
    }
  	redirect request.referrer
  end
  topic.comments.destroy
  topic.destroy
  session[:alert] = {
    style: 'alert-success',
    message: "Topic removed."
  }
  redirect "/forum/sections/#{topic.section}"
end

get '/forum/comment/:id/delete/?' do
	allowed [:user]
	comment = Comment.get(params[:id])
	unless session[:admin] || comment.user_id == session[:user]
		session[:alert] = {
    	style: 'alert-error',
    	message: "Sorry, you can't do that."
    }
		redirect request.referrer
	end
	comment.destroy
	session[:alert] = {
    style: 'alert-success',
    message: "Comment removed."
  }
  redirect "/forum/topic/#{comment.topic_id}" 
end


class Topic
	include DataMapper::Resource

	property   :id,         Serial
	property   :deleted_at, ParanoidDateTime
	timestamps :at
	
	property :title,        String
	property :description,  Text
	property :section,      String
	
	belongs_to :user
	has n, :comments

end

class Comment
  include DataMapper::Resource
  
  property   :id,         Serial
	property   :deleted_at, ParanoidDateTime
	timestamps :at
	
	property :body, Text
	
	belongs_to :user
	belongs_to :topic
	
end
