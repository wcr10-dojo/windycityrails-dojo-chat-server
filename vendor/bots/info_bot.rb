require File.expand_path("../bot_base", __FILE__)

class InfoBot < BotBase
  TALKS = {
    (Time.parse("2010-09-11 10:00:00AM")..Time.parse("2010-09-11 10:45:00AM")) => "Analyzing and Improving the Performance of your Rails Application with John McCaffrey",
    (Time.parse("2010-09-11 11:00:00AM")..Time.parse("2010-09-11 11:45:00AM")) => "It’s Time to Repay Your Debt with Kevin Gisi, Intridea",
    (Time.parse("2010-09-11 01:00:00PM")..Time.parse("2010-09-11 02:00:00PM")) => "Lightning Talks",
    (Time.parse("2010-09-11 02:15:00PM")..Time.parse("2010-09-11 03:00:00PM")) => "Weaving Design and Development with Ryan Singer, 37signals",
    (Time.parse("2010-09-11 03:15:00PM")..Time.parse("2010-09-11 04:00:00PM")) => "Grease your Suite: Tips and Tricks for Faster Testing with Nick Gauthier, SmartLogic Solutions",
    (Time.parse("2010-09-11 04:15:00PM")..Time.parse("2010-09-11 05:00:00PM")) => "Sustainably Awesome: How to Build a Team with Les Hill & Jim Remsik, Hashrocket",
    (Time.parse("2010-09-11 05:15:00PM")..Time.parse("2010-09-11 06:00:00PM")) => "What's New With Rails 3 with THE Yehuda Katz, Engine Yard"
  }
  
  def current_talk
    TALKS.each_pair { |time_range, message|
      return message if time_range === Time.now
    }
    "Looks like no talks are happening right now. Go talk to somebody!\n" +
    "Or better yet, come over to the Obtiva Coding Dojo!"
  end
  
  def msg_for_infobot?(message)
    if message =~ /#{username}: current talk/
      puts "InfoBot triggered!"
      true
    else
      puts "InfoBot dormant"
      false
    end
  end
  
  def respond(message_user, message_text)
    puts "InfoBot got: #{message_text}"
    if msg_for_infobot?(message_text)
      current_talk
    else
      nil
    end
  end
  
end

if __FILE__ == $0
  InfoBot.run!("infobot")
end