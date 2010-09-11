class Message
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
    now = Time.now
    message_json = {
      :username => user,
      :message => parse(message),
      :time_stamp => time_stamp(now),
      :email => email,
      :posted_at => now.strftime("%H:%M:%S")
      }.to_json
    RedisClient.redis.zadd("room:default", time_stamp, message_json)
  end
  
  def text
    @message
  end

  private

  def parse(message)
    @message = message
    add_image_tag
    @message
  end

  def add_image_tag
    return unless @message =~ /^http:\/\/.+\.(png|jpg|jpeg|gif)$/i 

    @message = %Q|<img src="#{@message}" />|
  end


  def time_stamp(time = Time.now)
    time.to_f * 1000
  end

end
