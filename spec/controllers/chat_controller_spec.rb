require 'spec_helper'

describe ChatController do
   before do 
      cookies[:username] = "tyler"
      RedisClient.redis = FakeRedis.new
    end

    it "should put the image into the redis store" do
      post :push, :message => "http://some_host/foo.png"  
      message = RedisClient.redis.zrange("room:default", 0, 1).first 
      json = ActiveSupport::JSON.decode(message)
      json["message"].should == '<img src="http://some_host/foo.png" />'
    end

    it "should support other image types" do
      %w(.png .gif .jpg .jpeg).each do |type|
	RedisClient.redis.reset!
	post :push, :message => "http://some_host/image#{type}"  
	message = RedisClient.redis.zrange("room:default", 0, 1).first 
	json = ActiveSupport::JSON.decode(message)
	json["message"].should == %Q|<img src="http://some_host/image#{type}" />|
      end
    end


    it "should only work for messages that contain a url" do 
      post :push, :message => "I like png"  
      message = RedisClient.redis.zrange("room:default", 0, 1).first 
      json = ActiveSupport::JSON.decode(message)
      json["message"].should == 'I like png'
    end
end
