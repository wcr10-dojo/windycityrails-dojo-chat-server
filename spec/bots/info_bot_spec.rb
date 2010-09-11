require 'spec_helper'
require File.expand_path('vendor/bots/info_bot')

describe InfoBot do
  before :all do
    @info_bot = InfoBot.new(:username)
  end
  
  describe 'current_talk' do
    it 'should return "Weaving Design and Development with Ryan Singer, 37signals"' do
      Time.stub!(:now => Time.parse("2010-09-11 02:55:00PM"))
      @info_bot.current_talk.should == "Weaving Design and Development with Ryan Singer, 37signals"
    end
  
    it 'should return default message' do
      Time.stub!(:now => Time.parse("2010-09-11 03:01:00PM"))
      @info_bot.current_talk.should == "Looks like no talks are happening right now. Go talk to somebody!\n" +
                                       "Or better yet, come over to the Obtiva Coding Dojo!"
    end
  end
  
  context "when checking for messages addressed to info bot" do
    it "has been messaged if message contains trigger" do
      @info_bot.msg_for_infobot?("#{:username}: current talk").should be_true
    end
    
    it "has not been message if no trigger present" do
      @info_bot.msg_for_infobot?("#{:username}: bar").should be_false
    end
  end
  
  describe 'should respond' do
    it 'with current talk' do
      @info_bot.should_receive(:msg_for_infobot?).and_return(true)
      @info_bot.should_receive(:current_talk).and_return('current talk')
      @info_bot.respond(:user, :message).should == 'current talk'
    end
    
    it 'with nil' do
      @info_bot.should_receive(:msg_for_infobot?).and_return(false)
      @info_bot.respond(:user, :message).should be_nil
    end
  end
end
