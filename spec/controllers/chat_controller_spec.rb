require 'spec_helper'

describe ChatController do
   before do 
      cookies[:username] = "tyler"
      RedisClient.redis = FakeRedis.new
    end
end
