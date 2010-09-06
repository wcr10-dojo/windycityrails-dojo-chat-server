class RedisController < ApplicationController
  def index
    @@redis ||= Redis.new
    args = params[:args] || ""
    render :text => @@redis.send(params[:command], *args.split(' ')).inspect
  end
end
