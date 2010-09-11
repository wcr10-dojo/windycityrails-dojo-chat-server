require 'spec_helper'

describe "a fake redis implementaiton for testing" do
  before do 
    @fake_redis = FakeRedis.new
  end

  it "supports sorted sets" do 
    @fake_redis.zadd("k", 2, "b")
    @fake_redis.zadd("k", 3, "c")
    @fake_redis.zadd("k", 1, "a")

    @fake_redis.zrange("k", 0, -1).should == ["a", "b", "c"]
    @fake_redis.zrevrange("k", 0, -1).should == ["c", "b", "a"]

    @fake_redis.zrangebyscore("k", 2, 3).should == ["b", "c"]
    @fake_redis.zrangebyscore("k", 2, "+inf").should == ["b", "c"]
    @fake_redis.zrangebyscore("k", "-inf", "+inf").should == ["a", "b", "c"]
  end
  
  it "enforces unique keys in sorted sets" do 
     @fake_redis.zadd("key", 2, "a_value")
     @fake_redis.zadd("key", 2, "a_value")
     
     @fake_redis.zrange("key", 0, -1).should == ["a_value"]
  end

end
