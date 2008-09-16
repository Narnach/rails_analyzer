module ArrayExt
  module GroupBy
    # Returns a Hash:
    # - The keys are grouping values
    # - The values are an Array with values grouped to that key.
    def group_by(&block)
      grouped_results = Hash.new { |hash, key| hash[key] = Array.new }
      each do |element|
        group_key = block.call(element)
        grouped_results[group_key] << element
      end
      grouped_results
    end
  end

  module Stats
    def avg
      sum / size.to_f
    end

    # Returns the median as a Float.
    def median
      return 0 if size == 0
      if size%2==0
        # Average two middle values
        # [1,2,3,4,5,6].median #=> 3.5
        (self[size / 2] + self[size / 2 - 1]) / 2.0
      else
        # Use middle value
        # [1,2,3,4,5].median #=> 3
        self[size / 2].to_f
      end
    end

    def stddev
      avg_cached = avg # prevent having to recompute it each time
      squared_deviations = map {|n| (n - avg_cached) ** 2 }
      variance = squared_deviations.avg
      Math::sqrt(variance)
    end

    def sum
      inject(0.0) {|s,n| s+n }
    end
  end
end

class Array
  include ArrayExt::GroupBy
  include ArrayExt::Stats
end