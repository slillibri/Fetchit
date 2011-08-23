class RateLimiter
  def self.current(addr)
    # @redis = Redis.connect
    $redis.get(addr) || 0
  end
  
  def self.ttl(addr)
    # @redis = Redis.connect
    $redis.ttl(addr)
  end
  
  def self.limit(addr)
    # @redis = Redis.connect
    
    ## Increment the key(returns the incremented value)
    limit = $redis.incr(addr)

    ## Set the key to expire (keys with no ttl return -1)
    unless $redis.ttl(addr) > 0
      $redis.expire(addr, RATE_EXPIRE)
    end

    if limit > RATE_LIMIT
      return true
    else
      return false
    end
  end
end
