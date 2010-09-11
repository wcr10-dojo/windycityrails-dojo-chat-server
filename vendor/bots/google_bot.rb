require 'net/http'
require 'uri'
require File.expand_path("../bot_base", __FILE__)

class GoogleBot < BotBase
  
  def respond(message_user, message_text)
    message_text.downcase!
    if message_user != username && message_text =~ /^search /
      message_text.gsub!(/^search /,'')
      url = lucky(message_text)
      return (url ? "<a href=\"#{url}\">#{url}</a>" : 'No result found')
    end
  end
  
  private
  
  def lucky(term)
    result = Net::HTTP.get(URI.parse("http://www.google.com/search?sclient=psy&hl=en&site=&source=hp&q=#{URI.encode(term)}&btnI=I%27m+Feeling+Lucky"))
    href = /.*HREF=\"(.*)\">.*/.match(result)
    unless href.nil?
      href[1]
    end
  end
  
end

if __FILE__ == $0
  GoogleBot.run!("Google Bot", :chat_server => "dojo-chat.local")
end