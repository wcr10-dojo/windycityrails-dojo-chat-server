require 'spec_helper'

describe ChatController do
   before do 
      cookies[:username] = "tyler"
      RedisClient.redis = FakeRedis.new
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

