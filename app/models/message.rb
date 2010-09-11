class Message
  
  def self.create!(user, params)
    new(user, params)
  end 

  def initialize(user, message)
    message_json = {:username => user, :message => parse(message), :time_stamp => time_stamp}.to_json
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


  def time_stamp
    Time.now.to_f * 1000
  end

end
