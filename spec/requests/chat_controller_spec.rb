require 'spec_helper'

describe "chat interactions" do
  it "redirects when the username cookie is not set" do
    get "/"
    response.should be_redirect
  end

  context "with a username" do 
    before do 
      cookies[:username] = "tyler"
      RedisClient.redis = FakeRedis.new
    end

    it "renders the initial chat page" do 
      get "/"
      response.should be_success
      response.should have_selector("div.chat_window")
    end
    
    it "pushes & pulls a chat message" do 
      post "/chat/push", :message => "Hello"
      get "/chat/pull/1"

      response.should contain("Hello")
    end

    it "allows multiple messages with the same content from the same user" do 
      post "/chat/push", :message => "Hello"
      post "/chat/push", :message => "Hello"
      get "/chat/pull/1"

      json = ActiveSupport::JSON.decode(response.body)
      json["delta"].size.should == 2
    end

    # Just do this here for now, since there are no view specs
    # and no cucumber
    it "sanitizes everything except images" do
      post "/chat/push", :message => "<script>alert('leeeerrrrooooyyyy')</script>"
      get "/"
      response.body.should_not =~ /alert/
    end

  end
end


