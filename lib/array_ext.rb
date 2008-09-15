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
end

class Array
  include ArrayExt::GroupBy
end