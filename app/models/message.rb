class Message
  
  PROCESSORS = %w(image youtube)
  
  attr_accessor :message
  
  def self.sanitize!(text)
    HTML::WhiteListSanitizer.new.sanitize(text)
  end

  class << self
    def create!(user, email, params)
      new(user, email, params)
    end

    def find_last
      RedisClient.redis.zrevrange("room:default", 0, 1).first
    end
  end

  def initialize(user, email, message)
    @message = parse(message)
    message_json = {
      :username => user,
      :message => @message,
      :time_stamp => time_stamp,
      :email => email}.to_json
    RedisClient.redis.zadd("room:default", time_stamp, message_json)
  end
  
  def text
    @message
  end

  private

  def parse(message)
    PROCESSORS.inject(message){|message, processor| "#{processor.capitalize}".constantize.process(message) || message }
  end

  def time_stamp
    Time.now.to_f * 1000
  end

end
