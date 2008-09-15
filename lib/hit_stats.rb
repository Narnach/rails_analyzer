require 'entries'
require 'uri'

class HitStats
  attr_accessor :logs, :hits_with_query, :hits_without_query

  def initialize(logs)
    @logs = logs
    @hits_with_query = Entries.new
    @hits_without_query = Entries.new
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
    File.open("log_hits.txt","wb") {|file| file.puts hits_without_query.to_s(:size) }
    File.open("log_avg.txt","wb") {|file| file.puts hits_without_query.to_s(:avg) }
    File.open("log_sum.txt","wb") {|file| file.puts hits_without_query.to_s(:sum) }
    File.open("log_median.txt","wb") {|file| file.puts hits_without_query.to_s(:median) }
    File.open("log_stddev.txt","wb") {|file| file.puts hits_without_query.to_s(:stddev) }
    File.open('log_sum_with_params.txt', 'wb') {|file| file.puts hits_with_query.to_s(:sum)}
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
      hits_with_query.add_hit(uri.to_s,time)
      uri.query=nil
      hits_without_query.add_hit(uri.to_s,time)
    end
  end
end