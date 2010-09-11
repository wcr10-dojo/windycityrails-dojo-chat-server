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

    context "signing in" do
      before { cookies[:username] = nil }
      
      it "should store the username in a cookie" do
        post :sign_in, :username => 'david'
        cookies["username"].should == 'david'
      end
      
      it "should redirect to #index on success" do
        post :sign_in, :username => 'david'
        response.should be_redirect
      end
      
      it "should store the e-mail address in a cookie if provided" do
        post :sign_in, :username => 'david', :email => 'ddemaree@metromix.com'
        cookies["email"].should == 'ddemaree@metromix.com'
      end
    end
end

