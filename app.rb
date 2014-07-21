require "sinatra"
require "active_record"
require "gschool_database_connection"
require "rack-flash"

class App < Sinatra::Application
  enable :sessions
  use Rack::Flash

  def initialize
    super
    @database_connection = GschoolDatabaseConnection::DatabaseConnection.establish(ENV["RACK_ENV"])
  end

  get "/" do
    messages = @database_connection.sql("SELECT * FROM messages")
    @comments = @database_connection.sql("SELECT * FROM comments")
    erb :home, locals: {messages: messages}
  end

  get '/messages/:id' do
    @id = params[:id]
    @message = @database_connection.sql("select message from messages where id = #{@id}").pop["message"]
    @comments = @database_connection.sql("SELECT * FROM comments")
    erb :message
  end

  post "/messages" do
    message = params[:message]
    if message.length <= 140
      @database_connection.sql("INSERT INTO messages (message) VALUES ('#{message}')")
    else
      flash[:error] = "Message must be less than 140 characters."
    end
    redirect "/"
  end

  get '/:index/edit' do
    @id = params[:index]
    @message = @database_connection.sql("select message from messages where id = #{@id}").pop["message"]
    erb :edit
  end

  patch '/:index' do
    id = params[:index]
    new_message = params[:message]
    if new_message.length <= 140
      @database_connection.sql("UPDATE messages SET message='#{new_message}' where id = #{id}")
    else
      flash[:error] = "Message must be less than 140 characters."
    end
    redirect '/'
  end

  delete '/:index/delete' do
    id = params[:index]
    @database_connection.sql("delete from messages where id = #{id}")
    redirect '/'
  end

  get '/add_comment/:index' do
    @message_id = params[:index]
    @message = @database_connection.sql("select message from messages where id = #{@message_id}").pop["message"]
    erb :add_comment
  end

  post '/post_comment/:id' do
    message_id = params[:id]
    comment = params[:comment]
    @database_connection.sql("insert into comments (comment, message_id) values ('#{comment}', #{message_id})")
    redirect '/'
  end

end