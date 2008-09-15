require 'time_stats'
require 'hit_stats'

class RailsAnalyzer
  attr_accessor :logs

  def initialize(logs=[])
    @logs = logs
    @logs = %w[log/production.log] if logs.size==0
  end

  def generate_reports
    puts "RailsAnalyzer"
    puts "Analyzes the following Rails log files:"
    puts logs.map{|l| '  %s' % l}.join("\n")

    puts 'Generating time-based reports'
    TimeStats.generate(logs)

    puts 'Generating hit-based reports'
    HitStats.generate(logs)
  end
end