# Add decent rounding to X decimals.
class Float
  def round_to(x=4)
    (self * 10**x).round.to_f / 10**x
  end

  def ceil_to(x=4)
    (self * 10**x).ceil.to_f / 10**x
  end

  def floor_to(x=4)
    (self * 10**x).floor.to_f / 10**x
  end
end

# Make statistical operations easier.
class Array
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

class PrettyLog
  @@entries={}

  attr_reader :url, :hit_times

  def self.add_hit(url,time)
    if @@entries[url].nil?
      @@entries[url]=self.new(url)
    end
    @@entries[url].add_hit(time)
  end

  def self.to_s(sort=:size)
    sort = :size unless [:size, :sum, :median, :stddev, :avg].include? sort
    sorted = @@entries.to_a.map {|k,v| v}.sort {|a,b| b.send(sort) <=> a.send(sort) }
    "Hits\tLow\tMedian\tAvg\tStddev\tHigh\tSum\tUrl\n" + sorted.map {|e| e.to_s}.join("\n")
  end

  def initialize(url)
    @url=url
    @hit_times=[]
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
    return "#{low.round_to}\t#{median.round_to}\t#{avg.round_to}\t#{stddev.round_to}\t#{high.round_to}\t#{sum.round_to}"
  end

  def to_s
    "#{size}\t#{self.time_stats}\t#{@url}"
  end
end

class ParamLog
  @@entries=Hash.new {|h,k| h[k] = self.new(k)}

  attr_reader :url, :hit_times

  def self.add_hit(url,time)
    @@entries[url].add_hit(time)
  end

  def self.to_s(sort=:size)
    sort = :size unless [:size, :sum, :median, :stddev, :avg].include? sort
    sorted = @@entries.select{|k,v| v.size > 10}.map {|k,v| v}.sort {|a,b| b.send(sort) <=> a.send(sort) }
    head = ('%6s ' + '%6s '*5 + '%9s %s') % %w[Hits Low Median Avg Stddev High Sum Url]
    # "Hits\tLow\tMedian\tAvg\tStddev\tHigh\tSum\tUrl\n" + sorted.map {|e| e.to_s}.join("\n")
    head << "\n" << sorted.join("\n")
  end

  def initialize(url)
    @url=url
    @hit_times=[]
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
    return '%3.03f %3.03f %3.03f %3.03f %3.03f %6.03f' % [low, median, avg, stddev, high, sum]
    # return ('%5.04f '*5 + '%6.03f') % [low, median, avg, stddev, high, sum]
    # return "#{low.round_to}\t#{median.round_to}\t#{avg.round_to}\t#{stddev.round_to}\t#{high.round_to}\t#{sum.round_to}"
  end

  def to_s
    return '%6i %s %s' % [size, time_stats, @url]
    # "#{size}\t#{self.time_stats}\t#{@url}"
  end
end
