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
    [:sum, :avg, :size, :median, :stddev].each do |sort_order|
      File.open("log_%s.txt" % sort_order,"wb") {|file| file.puts hits_without_query.to_s(sort_order) }
      File.open('log_%s_with_params.txt' % sort_order, 'wb') {|file| file.puts hits_with_query.to_s(sort_order)}
    end
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