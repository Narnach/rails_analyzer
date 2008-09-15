require 'array_ext'

class TimeStats
  attr_accessor :logs, :times

  def initialize(logs)
    @times = []
    @logs = logs
  end

  def self.generate(logs)
    ts = new(logs)
    ts.parse_files
    ts.save_reports
  end

  def parse_files
    logs.each do |log|
      results = `grep "Processing" #{log}`
      timestamps = results.map { |line| (line =~ /Processing.*\(for .* at (\d+-\d+-\d+ \d+:\d+:\d+)\)/) ? $1 : nil}.compact
      times.concat(timestamps)
    end
  end

  def save_reports
    %w[day hour day_hour].each do |timeframe|
      filename = 'log_times_%s.txt' % timeframe
      save_hits_report(filename, timeframe)
    end
    %w[hour ten_min].each do |timeframe|
      hits = self.send('per_%s' % timeframe).map {|frame, hits| hits.size}
      offset = hits.min || 0
      filename = 'log_times_%s_relative.txt' % timeframe
      save_hits_report(filename, timeframe, offset)
    end
  end

  protected
  
  def save_hits_report(filename, timeframe, offset = 0)
    collection = self.send('per_%s' % timeframe)
    File.open(filename,'wb') do |f|
      collection.each do |frame, hits|
        f.puts '%s: %s' % [frame, hits.size - offset]
      end
    end
  end

  def per_day_hour
    group_times_by {|d, h, m, s| '%s %sh' % [d, h]}
  end

  def per_day
    group_times_by {|d, h, m, s| d}
  end

  def per_hour
    group_times_by {|d, h, m, s| h}
  end

  def per_ten_min
    group_times_by {|d, h, m, s| '%sh%s0' % [h, m[0,1]]}
  end

  # Group times by date/time-related data.
  # Sorts by the yield return value
  # Returns an Array of two-element Arrays:
  # - The first element is the sort key
  # - The second element is the hit times for that key
  # The return value is sorted by key.
  def group_times_by(&block) # :yields: date, hour, min, sec
    grouped_times = times.group_by do |t|
      date, time = t.split(" ")
      hour, min, sec = time.split(":")
      block.call(date, hour, min, sec)
    end
    grouped_times.to_a.sort {|a,b| a.first <=> b.first}
  end
end