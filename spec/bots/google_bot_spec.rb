require 'spec_helper'
require File.expand_path('vendor/bots/google_bot')

describe GoogleBot do
  
  before do
    @username = 'Eric'
    @google_bot = GoogleBot.new(@username)
  end
  
  it "should respond with nil when the username is the same as the message username" do
    @google_bot.respond(@username, "search foo").should be nil
  end
  
  it "should respond with nil if the message text does not begin with 'search' " do
    @google_bot.respond("Jim", "some_other_text").should be nil
  end
  
  it "should respond with 'No result found' if the search term isn't lucky" do
    @google_bot.stub!(:lucky).and_return(nil)
    @google_bot.respond("Jim", "search foo").should == 'No result found'
  end
  
  it "should respond with an anchor tag if the search term is lucky" do
    url = "myurl.com"
    @google_bot.stub!(:lucky).and_return(url)
    @google_bot.respond("Jim", "search foo").should == "<a href=\"#{url}\">#{url}</a>"
  end
end
