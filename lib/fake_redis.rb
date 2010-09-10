class FakeRedis
  def initialize
    @data = {}
  end
  def zadd(key, score, message)
    @data[key] = [score, message]
  end

  def zrevrange(key, start_idx, end_idx)
    return unless value = @data[key]
    value[start_idx, end_idx]
  end
end
