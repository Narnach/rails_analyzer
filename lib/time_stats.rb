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
      File.open('log_times_%s.txt' % timeframe,'wb') do |f|
        self.send('per_%s' % timeframe).each do |frame, hits|
          f.puts '%s: %s' % [frame, hits.size]
        end
      end
    end
    File.open('log_times_hour_relative.txt','wb') do |f|
      min_hits = nil
      per_hour.each do |hour, hits|
        hit_count = hits.size
        min_hits ||= hit_count
        min_hits = hit_count if hit_count < min_hits
      end
      per_hour.each do |hour, hits|
        f.puts '%s: %s' % [hour, hits.size - min_hits]
      end
    end
    File.open('log_times_ten_min_relative.txt','wb') do |f|
      min_hits = nil
      per_ten_min.each do |ten_min, hits|
        hit_count = hits.size
        min_hits ||= hit_count
        min_hits = hit_count if hit_count < min_hits
      end
      per_ten_min.each do |ten_min, hits|
        f.puts '%s: %s' % [ten_min, hits.size - min_hits]
      end
    end
  end

  protected

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