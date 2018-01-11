module Supports
  module Plotting
    def union_for_charts(header, body)
      hash_from_array = {}
      0.upto(header.size - 1) do |index|
        hash_from_array[header[index]] = body[index]
      end
      hash_from_array
    end
  end
end