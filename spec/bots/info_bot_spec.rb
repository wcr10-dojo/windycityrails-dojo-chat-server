require File.expand_path('vendor/bots/info_bot')

describe InfoBot do
  
  it "should return the talk for a given time" do
    now = Time.now
    Time.stub(:now => now)
    InfoBot.stub(:talks => {((now - 10)..(now + 10)) => "foo"})
    
    @info_bot = InfoBot.new(:username)
    @info_bot.current_talk.should == "foo"
  end
  
  context "when checking for messages addressed to info bot" do
    it "has been messaged if message contains trigger" do
      info_bot = InfoBot.new(:username)
      info_bot.msg_for_infobot?("#{:username}: current talk").should be_true
    end
    
    it "has not been message if no trigger present" do
      info_bot = InfoBot.new(:username)
      info_bot.msg_for_infobot?("#{:username}: bar").should be_false
    end
  end
  
end