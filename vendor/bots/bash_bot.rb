require File.expand_path('../../../config/boot', __FILE__)
Bundler.require(:bot) if defined?(Bundler)
require 'cgi'

class BashQuote

  include HTTParty
  format :html
  
  def initialize(search="")
    @search = (search && search.strip) || ""
  end
  
  def quote    
    bash_url = @search == "" ? "http://bash.org/?random" : "http://bash.org/?search=#{@search}&sort=0&show=1"
    puts @search.inspect
    
    bash_result = Nokogiri::HTML(self.class.get(bash_url))
    bash_quote = bash_result.css("p.qt").first.content rescue "Error grabbing content from bash.org"

    puts %Q{Echoing "#{bash_quote}"}
    %Q{<blockquote><span class="quote">&ldquo;</span>#{CGI.escapeHTML(bash_quote).gsub(/\n/, "<br />")}</blockquote>}
  end
end

class BashBot
  include HTTParty
  headers 'Accept' => '*/*'
    
  attr_accessor :username, :last_updated, :options
  
  def initialize(username, options = {})
    self.username = username
    self.last_updated = 0
    self.options = options
  end
  
  def domain
    case self.class.env
    when "dev"
      "http://localhost:3000"
    when "prod"
      "http://dojo-chat.local"
    end
  end
  
  def run
    while true
      pull.each do |message|
        message_user = message["username"]
        message_text = message["message"]
        
        next if message_user == username
        
        if message_text.match /^bash:( (.*))?/
          bash = BashQuote.new($2)
          push(bash.quote)
        end
      end
      sleep 0.5
    end
  end
  
  def pull
    payload = self.class.get(domain + "/chat/pull/#{last_updated}")
    self.last_updated = payload["time"]
    payload["delta"]
  end
  
  def push(message)
    push_attrs = {:username => username, :message => message}    
    self.class.post(domain + "/chat/push", {:body => push_attrs})
  end
  
  def self.env=(env="dev")
    @env = env || "dev"
  end
  
  def self.env
    @env
  end
  
  def self.run!(username, options = {})
    bot = self.new(username, options)
    bot.run
  end
end

if __FILE__ == $0
  BashBot.env = ARGV[0]
  BashBot.run!("Bash.org")
end
