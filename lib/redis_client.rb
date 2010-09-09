module RedisClient
  def self.redis=(redis_connection)
    @redis = case redis_connection
             when Redis
               redis_connection
             when String
               Redis.new(redis_connection)
             else
               raise "I don't know what #{redis_connection.inspect}"
             end
  end

  def self.redis
    @redis
  end
end
