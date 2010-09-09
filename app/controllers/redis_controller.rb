class RedisController < ApplicationController

  def index
    args = params[:redis_args].split('/') || []
    render :text => RedisClient.redis.send(args[0], *args[1..-1]).inspect
  end
end
