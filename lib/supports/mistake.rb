module Supports
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