require File.expand_path('../../../config/boot', __FILE__)
Bundler.require(:bot) if defined?(Bundler)

class BotBase
  include HTTParty
  headers 'Accept' => '*/*'
  
  attr_accessor :username, :last_updated, :options
  
  def initialize(username, options = {})
    self.username = username
    self.last_updated = 0
    self.options = options
  end
  
  def run
    while true
      new_messages = pull
      new_messages.each do |message|
        response = respond(message["username"], message["message"])
        push(response) if response
      end
      sleep 0.5
    end
  end
  
  def respond(username, message)
    raise 'Please implement!'
  end
  
  def pull
    payload = self.class.get("http://localhost:3000/chat/pull/#{last_updated}")
    self.last_updated = payload["time"]
    payload["delta"]
  end
  
  def push(message)
    push_attrs = {:username => username, :message => message}    
    self.class.post("http://localhost:3000/chat/push", {:body => push_attrs})
  end
  
  def self.run!(username, options = {})
    bot = self.new(username, options)
    bot.run
  end
  
end