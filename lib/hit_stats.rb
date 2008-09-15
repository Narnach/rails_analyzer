require 'param_log'
require 'pretty_log'

class HitStats
  attr_accessor :logs

  def initialize(logs)
    @logs = logs
  end

  def self.generate(logs)
    hs = self.new(logs)
    hs.parse_logs
    hs.save_reports
  end

  def parse_logs
    logs.each do |log|
      parse_log(log)
    end
  end

  def save_reports
    File.open("log_hits.txt","wb") {|file| file.puts PrettyLog.to_s(:size) }
    File.open("log_avg.txt","wb") {|file| file.puts PrettyLog.to_s(:avg) }
    File.open("log_sum.txt","wb") {|file| file.puts PrettyLog.to_s(:sum) }
    File.open("log_median.txt","wb") {|file| file.puts PrettyLog.to_s(:median) }
    File.open("log_stddev.txt","wb") {|file| file.puts PrettyLog.to_s(:stddev) }
    File.open('log_sum_with_params.txt', 'wb') {|file| file.puts ParamLog.to_s(:sum)}
  end

  protected

  def parse_log(log)
    results = `grep "Completed" #{log}`
    results.each do |line|
      unless line =~ /\[(.*?)\]/
        puts "Failed to parse: #{line}"
        next
      end
      next unless uri=URI.parse($1) rescue nil
      unless line =~ /Completed\ in\ ([0-9]+\.[0-9]+)/
        puts "Could not extract time from line: #{line}"
      end
      time = $1.to_f
      ParamLog.add_hit(uri.to_s,time)
      uri.query=nil
      PrettyLog.add_hit(uri.to_s,time)
    end
  end
end