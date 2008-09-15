require 'float_ext'

class UrlHits < Array
  attr_reader :url
  
  def initialize(url)
    @url = url
  end

  def add_hit(time)
    self << time
  end

  def to_s
    '%6i %s %s' % [size, time_stats, @url]
  end

  def avg
    sum / size.to_f
  end

  def median
    return 0 if size == 0
    if size%2==0
      # Average two middle values
      # [1,2,3,4,5,6].median #=> 3.5
      (self[size / 2] + self[size / 2 - 1]) / 2
    else
      # Use middle value
      # [1,2,3,4,5].median #=> 3
      self[size / 2]
    end
  end

  def stddev
    mean = sum / size.to_f
    diffs = map {|n| n - mean }
    sqdiffs = diffs.map {|n| n * n }
    sqsum = sqdiffs.sum
    sqmean = sqsum / size.to_f
    Math::sqrt(sqmean)
  end

  def sum
    inject(0.0) {|s,n| s+n }
  end

  protected

  def time_stats
    return nil unless size > 0
    '%3.03f %3.03f %3.03f %3.03f %3.03f %6.03f' % [min, median, avg, stddev, max, sum]
  end
end