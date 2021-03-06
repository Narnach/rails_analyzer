require File.dirname(__FILE__) + '/spec_helper'
require 'array_ext'

describe ArrayExt::GroupBy do
  it 'should be included in Array' do
    Array.included_modules.should include(ArrayExt::GroupBy)
  end

  describe '#group_by' do
    before(:each) do
      @array = [1,2,3,4]
    end

    it 'should return a Hash of block return values and Arrays of elements with the same return values' do
      @array.group_by {|e| e % 2}.should == {0 => [2,4], 1=>[1,3]}
    end
  end
end

describe ArrayExt::Stats do
  it 'should be included in Array' do
    Array.included_modules.should include(ArrayExt::Stats)
  end

  describe '#avg' do
    it 'should return the average of all elements' do
      [1,2,3].avg.should == 2
      [1,2].avg.should == 1.5
    end
  end

  describe '#median' do
    it 'should return the median of all elements' do
      [1,2,3].median.should == 2
      [1,3,4,5,5].median.should == 4
      [1,2,3,4].median.should == 2.5
      [1.1,2.3].median.should == 1.7
    end
  end

  describe '#stddev' do
    it 'should return the standard deviation of all elements' do
      [3,7,7,19].stddev.should == 6

      input = [1.1, 2, 3, 4, 5.5, 99.99]
      mean = input.avg
      stddev = Math::sqrt(input.map {|n| (n - mean) ** 2 }.avg)
      input.stddev.should == stddev
    end
  end

  describe '#sum' do
    it 'should return the sum of all elements' do
      [1,2,3].sum.should == 6
      [1.1,2].sum.should == 3.1
    end
  end
end