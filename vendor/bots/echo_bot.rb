require File.expand_path('../../../config/boot', __FILE__)
require File.join(File.dirname(__FILE__), 'bot_base')
Bundler.require(:bot) if defined?(Bundler)

class EchoBot < BotBase
  include HTTParty
  headers 'Accept' => '*/*'
  
  attr_accessor :username, :last_updated, :options
  
  def respond
    new_messages = pull
    new_messages.each do |message|
      process_message message
    end  
  end
  
  def self.run!(username, options = {})
    bot = self.new(username, options)
    bot.run
  end

  def process_message message
    message_user = message["username"]
    message_text = message["message"]
       
    push(message_text) if message_user != username
  end


end

if __FILE__ == $0
  EchoBot.run!("Annoy-o-Tron-omatic")
end