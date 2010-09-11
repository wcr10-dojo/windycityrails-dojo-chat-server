require File.expand_path('../../../config/boot', __FILE__)
require 'net/http'
require 'uri'
Bundler.require(:bot) if defined?(Bundler)

class GoogleBot
  include HTTParty
  headers 'Accept' => '*/*'
  
  attr_accessor :username, :last_updated, :chat_server
  
  def initialize(username, chat_server)
    self.username = username
    self.last_updated = 0
    self.chat_server = chat_server
  end
  
  def term(message)
    message
  end
  
  def post!(url)
    Message.create!('Google Bot',"<a href=\"#{url}\">#{url}</a>")
  end
  
  
  def run
    while true
      new_messages = pull
      new_messages.each do |message|
        message_user = message["username"]
        message_text = message["message"]
      
        next if message_user == username
        
        unless (message_text =~ /^search /).nil?
          message_text.gsub!(/^search /,'')
          puts %Q{Googling "#{message_text}" from #{message_user}}
          url = lucky(message_text)
          unless url.nil?
            push("<a href=\"#{url}\">#{url}</a>")
          else
            push('No result found')
          end
        end
      end
      sleep 0.5
    end
  end
  
  def pull
    payload = self.class.get("http://#{self.chat_server}/chat/pull/#{last_updated}")
    self.last_updated = payload["time"]
    payload["delta"]
  end
  
  def push(message)
    push_attrs = {:username => username, :message => message}    
    self.class.post("http://#{self.chat_server}/chat/push", {:body => push_attrs})
  end
  
  def self.run!(username, chat_server = 'localhost:3000')
    bot = self.new(username, chat_server)
    bot.run
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
  GoogleBot.run!("Google Bot", "dojo-chat.local")
end