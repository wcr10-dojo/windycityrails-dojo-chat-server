class FakeRedis
  def initialize
    @data = {}
  end

  def reset!
    @data = {}
  end

  def zadd(key, score, message)
    @data[key] = (@data[key] || [])
    @data[key] << [score, message]
  end

  def zrange(key, start_idx, end_idx)
    return unless @data[key]
    zvalues(zsort(key))[start_idx .. end_idx]
  end

  def zrevrange(key, start_idx, end_idx)
    zrange(key, start_idx, end_idx).try(:reverse)
  end

  def zrangebyscore(key, start_score, end_score)
    end_score = translante_infinity(end_score)
    start_score = translante_infinity(start_score)
    range = (start_score .. end_score)
    zvalues zsort(key).select{|s, v| range.include?(s)}
  end
  
  def flushall
    @data = {}
  end

  protected
  Infinity = 1.0/0

  def translante_infinity(v)
    return v unless ["+inf", "-inf"].include?(v)
    return Infinity if v == "+inf"
    return -Infinity if v == "-inf"
  end
  def zsort(key)
    @data[key].sort_by{|s, v| s}
  end

  def zvalues(raw)
    raw.map{|s, v| v}.uniq
  end
end
