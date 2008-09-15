require File.dirname(__FILE__) + '/spec_helper'
require 'entries'

describe Entries do
  describe '#add_hit' do
    it 'should be stored grouped per URL' do
      u = 'http://www.example.org'
      u2 = 'http://www2.example.org'
      uh1 = UrlHits.new(u)
      uh1.add_hit(0.1)
      uh2 = UrlHits.new(u)
      uh2.add_hit(0.1)
      uh2.add_hit(0.2)
      uh3 = UrlHits.new(u)
      uh3.add_hit(0.1)
      uh3.add_hit(0.2)
      uh3.add_hit(0.3)
      uh4 = UrlHits.new(u2)
      uh4.add_hit(0.1)

      e = Entries.new
      e.entries.should == {}
      e.add_hit(u, 0.1)
      e.entries.should == {u => uh1}
      e.add_hit(u, 0.2)
      e.entries.should == {u => uh2}
      e.add_hit(u, 0.3)
      e.entries.should == {u => uh3}
      e.add_hit(u2, 0.1)
      e.entries.should == {u => uh3, u2 => uh4}
    end
  end

  describe '#to_s' do
    it "should return a summary of the url hit times" do
      e = Entries.new
      e.add_hit('http://www.example.org', 0.1)
      e.add_hit('http://www.example.org', 0.2)
      e.add_hit('http://www.example.org', 0.3)
      expected_output = '' + \
        '  Hits    Low Median    Avg Stddev   High       Sum Url' + "\n" + \
        '     3 0.100 0.200 0.200 0.082 0.300  0.600 http://www.example.org'
      e.to_s.should == expected_output
    end
  end
end
