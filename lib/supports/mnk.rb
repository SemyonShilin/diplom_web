module Supports
  module MNK
    def in_degree_n(array, n = 2)
      array.map { |y_i| y_i**n }
    end

    def x_in_degree_n_on_y(x, y, n = 1)
      temp = []
      x.size.times { |index| temp << in_degree_n(x, n)[index] * y[index] }
      temp
    end

    def mult(array1, array2)
      temp = []
      array1.size.times { |index| temp << array1[index] * array2[index] }
      temp
    end

    def median(array)
      raise ArgumentError, 'Cannot find the median on an empty array' if array.size == 0
      sorted = array.sort
      midpoint, remainder = sorted.length.divmod(2)
      remainder.zero? ? sorted[midpoint - 1, 2].inject(:+) / 2.0 : sorted[midpoint]
    end

    def set_range(min, max)
      (min..max).step(0.001).to_a
    end
  end
end