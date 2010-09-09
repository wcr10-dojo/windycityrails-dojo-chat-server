class ChatController < ApplicationController
  before_filter :check_cookie, :except => [:sign_in_form, :sign_in]

  def index
    @recent_messages = (RedisClient.redis.zrevrange("room:default", 0, 30) || []).map {|m| m.split('^')}
  end

  def sign_in
    cookies[:username] = params[:username]
    #TODO: need to store this in redis
    redirect_to :action => :index
  end

  def push
    message = cookies[:username] + "^" + params[:message]
    RedisClient.redis.zadd("room:default", Time.now.to_f * 1000, message)

    render :nothing => true
  end

  def pull
   delta = RedisClient.redis.zrangebyscore 'room:default', params[:last_sync].to_f + 0.01, '+inf' 
   messages = (delta || []).map { |message| message.split('^') }
   render :json => {:time => Time.now.to_f * 1000, :delta => messages}
  end

  protected

  def check_cookie
    redirect_to :action => :sign_in_form unless cookies[:username]
  end
end
