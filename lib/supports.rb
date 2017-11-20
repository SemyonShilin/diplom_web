module Supports
  module MNK
    def in_degree_n(array, n = 2)
      array.map { |y_i| y_i**n }
    end

    def x_in_degree_n_on_y(x, y, n = 1)
      temp = []
      x.size.times do |index|
        temp << in_degree_n(x, n)[index] * y[index]
      end
      temp
    end

    def y_in_divisible_by_x(n1, n2 = 0)
      temp = []
      x.size.times do |index|
        temp << y_in_degree_n(n2)[index] / x_in_degree_n(n1)[index]
      end
      temp
    end

    def mult(array1, array2)
      temp = []
      array1.size.times do |index|
        temp << array1[index]*array2[index]
      end
      temp
    end
  end

  module Plotting
    def union_for_charts(header, body)
      hash_from_array = {}
      0.upto(header.size - 1) do |index|
        hash_from_array[header[index]] = body[index]
      end
      hash_from_array
    end
  end

  module Mistake
    def self.sum_approximation(y, y_a)
      sum = 0
      y.size.times do |index|
        sum += (y[index] - y_a[index])**2
      end
      sum
    end

    def self.calculate(y, **data)
      temp = {}
      data.each do |key, value|
        temp[key] = sum_approximation(y, value)
      end
      temp
    end
  end
end