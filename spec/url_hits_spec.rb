require File.dirname(__FILE__) + '/spec_helper'
require 'url_hits'

describe UrlHits do
  describe '#to_s' do
    it "should return a summary of the url hit times" do
      uh = UrlHits.new('http://www.example.org')
      uh.add_hit(0.1)
      uh.to_s.should == '     1 0.100 0.100 0.100 0.000 0.100  0.100 http://www.example.org'
      uh.add_hit(0.2)
      uh.to_s.should == '     2 0.100 0.150 0.150 0.050 0.200  0.300 http://www.example.org'
      uh.add_hit(0.3)
      uh.to_s.should == '     3 0.100 0.200 0.200 0.082 0.300  0.600 http://www.example.org'
    end
  end
end
