require 'url_hits'

class Entries
  attr_accessor :entries

  def initialize
    @entries = Hash.new { |hash, url| hash[url] = UrlHits.new(url) }
  end

  def add_hit(url, time)
    entries[url].add_hit(time)
  end

  def to_s(sort=:size)
    sorted = entries.values.sort {|a,b| b.send(sort) <=> a.send(sort) }
    head = ('%6s ' + '%6s '*5 + '%9s %s') % %w[Hits Low Median Avg Stddev High Sum Url]
    head << "\n" << sorted.join("\n")
  end
end