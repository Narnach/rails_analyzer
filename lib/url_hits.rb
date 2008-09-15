require 'float_ext'
require 'array_ext'

class UrlHits
  attr_reader :url, :hit_times
  
  def initialize(url)
    @url = url
    @hit_times = []
  end
  
  def method_missing(meth,*args,&block)
    if [:sum, :median, :stddev, :size].include? meth
      hit_times.send(meth,*args,&block)
    else
      super(meth,*args,&block)
    end
  end

  def avg
    sum / size.to_f
  end

  def add_hit(time)
    @hit_times << time
  end

  def time_stats
    return nil unless size > 0
    low, high = hit_times.min, hit_times.max
    '%3.03f %3.03f %3.03f %3.03f %3.03f %6.03f' % [low, median, avg, stddev, high, sum]
  end

  def to_s
    '%6i %s %s' % [size, time_stats, @url]
  end
end