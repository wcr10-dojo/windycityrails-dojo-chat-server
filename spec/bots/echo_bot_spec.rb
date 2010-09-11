require 'spec_helper'
require File.expand_path('vendor/bots/echo_bot')

describe EchoBot do
  
  describe "should initialize" do 
    after :each do
      @eb.username.should == 'username'
      @eb.last_updated.should == 0
    end
    
    it "with options" do
      hash = {:echo => true}
      @eb=EchoBot.new('username',hash)
      @eb.options.should == hash
    end
    
    it "without options" do
      @eb=EchoBot.new('username')
      @eb.options.should be_empty   
    end    
  end
  
  describe "should respond" do
    before :all do
      @eb=EchoBot.new('EchoBot')
    end
    it 'echo message from another user' do
      @eb.respond('user', 'message').should == 'message'
    end
    
    it 'with nil to myself' do
      @eb.respond('EchoBot', 'message').should be_nil
    end
  end
end
