class FakeRedis
  def initialize
    @data = {}
  end
  def zadd(key, score, message)
    @data[key] = (@data[key] || [])
    @data[key] << [score, message]
  end

  def zrange(key, start_idx, end_idx)
    return unless @data[key]
    @data[key].sort_by{|s, v| s}.map{|s, v| v}[start_idx .. end_idx]
  end

  def zrevrange(key, start_idx, end_idx)
    zrange(key, start_idx, end_idx).try(:reverse)
  end
end
