require 'rubygems'
require 'activesupport'

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
    times.group_by do |t|
      date, time = t.split(" ")
      hour, min, sec = time.split(":")
      '%s %sh' % [date, hour]
    end
  end

  def per_day
    times.group_by do |t|
      date, time = t.split(" ")
      date
    end
  end

  def per_hour
    times.group_by do |t|
      date, time = t.split(" ")
      hour, min, sec = time.split(":")
      hour
    end
  end

  def per_ten_min
    times.group_by do |t|
      date, time = t.split(" ")
      hour, min, sec = time.split(":")
      '%sh%s0' % [hour, min[0,1]]
    end
  end
end