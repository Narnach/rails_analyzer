require 'float_ext'
require 'array_ext'

class UrlHits
  attr_reader :url, :hits
  
  def initialize(url)
    @url = url
    @hits = Array.new
  end

  def add_hit(time)
    hits << time
  end

  def to_s
    '%6i %s %s' % [size, time_stats, @url]
  end

  def ==(other)
    (other.class == self.class) && (other.url == self.url) && (other.hits == self.hits)
  end

  [:size, :min, :max, :sum, :stddev, :median, :avg].each do |op|
    define_method(op) do
      hits.send(op)
    end
  end

  protected

  def time_stats
    return nil unless size > 0
    '%3.03f %3.03f %3.03f %3.03f %3.03f %6.03f' % [min, median, avg, stddev, max, sum]
  end
end