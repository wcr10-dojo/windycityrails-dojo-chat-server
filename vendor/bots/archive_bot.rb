require File.expand_path('../../../config/boot', __FILE__)
Bundler.require(:bot) if defined?(Bundler)
require 'active_support'

class ArchiveBot
  include HTTParty
  headers 'Accept' => '*/*'
  
  attr_accessor :username, :last_updated, :options
  
  def initialize(username, options = {})
    self.username = username
    self.last_updated = 0
    self.options = options
    self.options[:base_url] ||= 'http://localhost:3000'
    self.options[:log_file] ||= 'log/chat-archive.log'
  end
  
  def run
    while true
      new_messages = pull
      new_messages.each do |message|
        message_user = message["username"]
        message_text = message["message"]
        
        next if message_user == username
        
        puts %Q{Archiving "#{message_text}" from #{message_user}}
        File.open(options[:log_file], 'a') {|f| f.write("#{ActiveSupport::JSON.encode(message)}\n") }
      end
      sleep 0.5
    end
  end
  
  def pull
    payload = self.class.get("#{options[:base_url]}/chat/pull/#{last_updated}")
    self.last_updated = payload["time"]
    payload["delta"]
  end
  
  def push(message)
    push_attrs = {:username => username, :message => message}    
    self.class.post("#{options[:base_url]}/chat/push", {:body => push_attrs})
  end
  
  def self.run!(username, options = {})
    bot = self.new(username, options)
    bot.run
  end
end

if __FILE__ == $0
  ArchiveBot.run!("Archiver", :base_url => ARGV[0], :log_file => ARGV[1])
end
