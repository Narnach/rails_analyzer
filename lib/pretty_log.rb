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
