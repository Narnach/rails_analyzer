# Make statistical operations easier.
module ArrayExt
  def sum
    inject(0.0) {|s,n| s+n }
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
end

class Array
  include ArrayExt
end