class RedisController < ApplicationController
  def index
    args = params[:redis_args].split('/') || []
    render :json => RedisClient.redis.send(args[0], *args[1..-1])
  end
end
