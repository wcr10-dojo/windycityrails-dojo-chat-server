require 'net/http'
require 'uri'
require File.expand_path("../bot_base", __FILE__)

class GoogleBot < BotBase
  
  def respond(message_user, message_text)
    if message_user == username
      nil
    else
       message_text.downcase!
      unless (message_text =~ /^search /).nil?
        message_text.gsub!(/^search /,'')
        puts %Q{Googling "#{message_text}" from #{message_user}}
        url = lucky(message_text)
        unless url.nil?
          result = "<a href=\"#{url}\">#{url}</a>"
        else
          result = 'No result found'
        end
      end
      result
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