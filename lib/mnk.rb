require 'mathn'
require 'matrix'
require 'nmatrix'
# require 'linefit'
# require 'binary_search/native'

module MNK
  module TestPar
    # def self.testes(x, y)
    #   lineFit = LineFit.new
    #   # x = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18]
    #   # y = [4039,4057,4052,4094,4104,4110,4154,4161,4186,4195,4229,4244,4242,4283,4322,4333,4368,4389]
    #
    #   lineFit.setData(x,y)
    #
    #   intercept, slope = lineFit.coefficients
    #   rSquared = lineFit.rSquared
    #   meanSquaredError = lineFit.meanSqError
    #   durbinWatson = lineFit.durbinWatson
    #   sigma = lineFit.sigma
    #   tStatIntercept, tStatSlope = lineFit.tStatistics
    #   predictedYs = lineFit.predictedYs
    #   residuals = lineFit.residuals
    #   varianceIntercept, varianceSlope = lineFit.varianceOfEstimates
    #
    #   print "Slope: #{slope}  Y-Intercept: #{intercept}\n"
    #   print "r-Squared: #{rSquared}\n"
    #   print "Mean Squared Error: #{meanSquaredError}\n"
    #   print "Durbin Watson Test: #{durbinWatson}\n"
    #   print "Sigma: #{sigma}\n"
    #   print "t Stat Intercept: #{tStatIntercept}  t Stat Slope: #{tStatSlope}\n\n"
    #   print "Predicted Ys: #{predictedYs.inspect}\n\n"
    #   print "Residuals: #{residuals.inspect}\n\n"
    #   print "Variance Intercept: #{varianceIntercept}   Variance Slope: #{varianceSlope}\n"
    #   print "\n"
    #
    #   newX = 24
    #   newY = lineFit.forecast(newX)
    #   print "New X: #{newX}\nNew Y: #{newY}\n"
    #   predictedYs
    # end

    extend Supports::MNK

    def self.testes(x, y)
      general_determinant(x).solve(determinant_a(x, y))
    end

    private

    def self.general_determinant(x)
      NMatrix.new([4, 4], [in_degree_n(x, 3).sum, in_degree_n(x).sum, x.sum, x.size,
             in_degree_n(x, 4).sum, in_degree_n(x, 3).sum, in_degree_n(x).sum, x.sum,
             in_degree_n(x, 5).sum, in_degree_n(x, 4).sum, in_degree_n(x, 3).sum, in_degree_n(x).sum,
             in_degree_n(x, 6).sum, in_degree_n(x, 5).sum, in_degree_n(x, 4).sum, in_degree_n(x, 3).sum], dtype: :float64)
    end

    def self.determinant_a(x, y)
      NMatrix.new([4, 1], [y.sum,
             x_in_degree_n_on_y(x, y).sum,
             x_in_degree_n_on_y(x, y, 2).sum,
             x_in_degree_n_on_y(x, y, 3).sum], dtype: :float64)
    end
  end

  module TestHyp
    extend Supports::MNK

    def self.testes(x, y)
      params = %w(a b d)
      coefficients = []
      params.each do |p|
        coefficients << send("coefficient_#{p}", x, y)
      end
      p coefficients
      # p coefficients << send("coefficient_d", x, y)
    end

    # через бинарный поиск

    def self.coefficient_a(x, y)
      (x.last*y.last + (y.last - y.first)*coefficient_d(x, y))/x.last
    end

    def self.coefficient_b(x, y)
      y.first*coefficient_d(x, y)
    end

    def self.coefficient_d(x, y)
      # array_for_d.bsearch do |d|
      #   d >= (y.sum - (x.last*y.last*x.sum + ((y.last-y.first)*x.sum + y.first*x.first)*d)/(x.sum+d*x.size))*
      #   (((y.last-y.first)*x.sum + y.first*x.first)*(x.sum+d) - (x.last*y.last*x.sum + ((y.last-y.first)*x.sum + y.first*x.first)*d))/
      #       (x.sum + d)**2
      # end
      # temp = []
      # temp << array_for_d.bsearch do |d|
      #
      #   d <= ((y.sum - (x.last*y.last*x.sum + ((y.last-y.first)*x.sum + y.first*x.first)*d)/(x.sum+d*x.size))*
      #   (((y.last-y.first)*x.sum + y.first*x.first)*(x.sum+d) - (x.last*y.last*x.sum + ((y.last-y.first)*x.sum + y.first*x.first)*d))/
      #       (x.sum + d)**2)
      # end
      # p temp

      array_for_d.bsearch do |d|
        temp ||=((y.sum - (x.last*y.last*x.sum + ((y.last-y.first)*x.sum + y.first*x.first)*d)/(x.sum+d*x.size))*
            (((y.last-y.first)*x.sum + y.first*x.first)*(x.sum+d) - (x.last*y.last*x.sum + ((y.last-y.first)*x.sum + y.first*x.first)*d))/
            (x.sum + d)**2)
        if temp.round <= d.round
          return temp
        end
      end
      # p ((y.sum - (x.last*y.last*x.sum + ((y.last-y.first)*x.sum + y.first*x.first)*d)/(x.sum+d*x.size))*
      #     (((y.last-y.first)*x.sum + y.first*x.first)*(x.sum+d) - (x.last*y.last*x.sum + ((y.last-y.first)*x.sum + y.first*x.first)*d))/
      #     (x.sum + d)**2)
    end

    # def range_zero
    #   temp = []
    #   array_for_d.each do |d|
    #     rrr = ((y.last-y.first)*sum(x_in_degree_n) + x.last*y.first*sum(x_in_degree_n(1)) + (y.last-y.first)*sum(x_in_degree_n(1))*d + 2*x.last*y.first*d*x.size -
    #       x.last*y.last*sum(x_in_degree_n(1)) + (y.last-y.first)*sum(x_in_degree_n) + x.last*y.first*sum(x_in_degree_n(1)) + (y.last-y.first)*d*sum(x_in_degree_n(1)) + x.last*y.first*d*x.size)/(sum(x_in_degree_n)+2*sum(x_in_degree_n(1))*d + x.size*d**2)
    #     if rrr == 0
    #       temp << d
    #     end
    #   end
    #    temp
    #
    # end

    def self.array_for_d
      temp = []
      (0).step(by: 1, to: 30000000){|elem| temp << elem}
      temp
    end
  end

  module CubicParabola
    extend Supports::MNK

    def self.calculate_coefficients(x, y)
      params = %w(a b c d)
      coefficients = []
      params.each do |p|
        coefficients << (send("determinant_#{p}", x, y) / general_determinant(x))
      end
      coefficients
    end

    private

    def self.general_determinant(x)
      Matrix[[in_degree_n(x, 3).sum, in_degree_n(x).sum, x.sum, x.size],
             [in_degree_n(x, 4).sum, in_degree_n(x, 3).sum, in_degree_n(x).sum, x.sum],
             [in_degree_n(x, 5).sum, in_degree_n(x, 4).sum, in_degree_n(x, 3).sum, in_degree_n(x).sum],
             [in_degree_n(x, 6).sum, in_degree_n(x, 5).sum, in_degree_n(x, 4).sum, in_degree_n(x, 3).sum]].det
    end

    def self.determinant_a(x, y)
      Matrix[[y.sum, in_degree_n(x).sum, x.sum, x.size],
             [x_in_degree_n_on_y(x, y).sum, in_degree_n(x, 3).sum, in_degree_n(x).sum, x.sum],
             [x_in_degree_n_on_y(x, y, 2).sum, in_degree_n(x, 4).sum, in_degree_n(x, 3).sum, in_degree_n(x).sum],
             [x_in_degree_n_on_y(x, y, 3).sum, in_degree_n(x, 5).sum, in_degree_n(x, 4).sum, in_degree_n(x, 3).sum]].det
    end

    def self.determinant_b(x, y)
      Matrix[[in_degree_n(x, 3).sum, y.sum, x.sum, x.size],
             [in_degree_n(x, 4).sum, x_in_degree_n_on_y(x, y).sum, in_degree_n(x).sum, x.sum],
             [in_degree_n(x, 5).sum, x_in_degree_n_on_y(x, y, 2).sum, in_degree_n(x, 3).sum, in_degree_n(x).sum],
             [in_degree_n(x, 6).sum, x_in_degree_n_on_y(x, y, 3).sum, in_degree_n(x, 4).sum, in_degree_n(x, 3).sum]].det
    end

    def self.determinant_c(x, y)
      Matrix[[in_degree_n(x, 3).sum, in_degree_n(x).sum, y.sum, x.size],
             [in_degree_n(x, 4).sum, in_degree_n(x, 3).sum, x_in_degree_n_on_y(x, y).sum, x.sum],
             [in_degree_n(x, 5).sum, in_degree_n(x, 4).sum, x_in_degree_n_on_y(x, y, 2).sum, in_degree_n(x).sum],
             [in_degree_n(x, 6).sum, in_degree_n(x, 5).sum, x_in_degree_n_on_y(x,y, 3).sum, in_degree_n(x, 3).sum]].det
    end

    def self.determinant_d(x, y)
      Matrix[[in_degree_n(x, 3).sum, in_degree_n(x).sum, x.sum, y.sum],
             [in_degree_n(x, 4).sum, in_degree_n(x, 3).sum, in_degree_n(x).sum, x_in_degree_n_on_y(x, y).sum],
             [in_degree_n(x, 5).sum, in_degree_n(x, 4).sum, in_degree_n(x, 3).sum, x_in_degree_n_on_y(x, y, 2).sum],
             [in_degree_n(x, 6).sum, in_degree_n(x, 5).sum, in_degree_n(x, 4).sum, x_in_degree_n_on_y(x, y, 3).sum]].det
    end
  end

  module Hyperbola
    extend Supports::MNK

    def self.calculate_coefficients(x, y)
      params = %w(a b d)
      coefficients = []
      params.each do |p|
        coefficients << send("coefficient_#{p}", x, y)
      end
      coefficients
    end

    def self.coefficient_a(x, y)
      (x.last*y.last + (y.last-y.first)*coefficient_d(x, y))/x.last
    end

    def self.coefficient_b(x, y)
      y.first*coefficient_d(x, y)
    end

    def self.coefficient_d(x, y)
      -(determinant_k2(x, y) / general_determinant(x, y))
    end

    private

    def self.general_determinant(x, y)
      Matrix[[in_degree_n(x).sum, in_degree_n(x, 1).sum, x_in_degree_n_on_y(x, y).sum],
             [x_in_degree_n_on_y(x, y).sum, in_degree_n(y, 1).sum, in_degree_n(y).sum],
             [in_degree_n(x, 1).sum, in_degree_n(y, 1).sum, x.size]].det
    end

    def self.determinant_k1(x, y)
      Matrix[[x_in_degree_n_on_y(x, y, 2).sum, in_degree_n(x, 1).sum, x_in_degree_n_on_y(x, y)],
             [mult(x_in_degree_n_on_y(x, y), in_degree_n(y, 1)).sum, in_degree_n(y, 1).sum, in_degree_n(y).sum],
             [x_in_degree_n_on_y(x, y).sum, in_degree_n(y, 1).sum, x.size]].det
    end

    def self.determinant_k2(x, y)
      Matrix[[in_degree_n(x).sum, x_in_degree_n_on_y(x, y, 2).sum, x_in_degree_n_on_y(x, y).sum],
             [x_in_degree_n_on_y(x, y).sum, mult(x_in_degree_n_on_y(x, y), in_degree_n(y, 1)).sum, in_degree_n(y).sum],
             [in_degree_n(x, 1).sum, x_in_degree_n_on_y(x, y).sum, x.size]].det
    end

    def self.determinant_k3(x, y)
      Matrix[[in_degree_n(x).sum, in_degree_n(x, 1).sum, x_in_degree_n_on_y(x, y, 2).sum],
             [x_in_degree_n_on_y(x, y).sum, in_degree_n(y, 1).sum, mult(x_in_degree_n_on_y(x, y), in_degree_n(y, 1)).sum],
             [in_degree_n(x, 1).sum, in_degree_n(y, 1).sum, x_in_degree_n_on_y(x, y).sum]].det
    end
  end

  module CubicParabolaWithExtremes
    extend Supports::MNK

    def self.calculate_coefficients(x, y)
      coefficients = []
      params = %w(a b c d)

      params.each do |p|
        coefficients << send("coefficient_#{p}", x, y)
      end
      coefficients
    end

    def self.coefficient_a(x, y)
      determinant_a(x, y) / general_determinant(x)
    end

    def self.coefficient_b(x, y)
      determinant_b(x, y) / general_determinant(x)
    end

    def self.coefficient_c(x, y)
      (y.last - coefficient_a(x, y) * x.last**3 - coefficient_b(x, y) * x.last**2 - y.first)/x.last
    end

    def self.coefficient_d(x, y)
      y.first
    end

    private

    def self.general_determinant(x)
      Matrix[[in_degree_n(x, 4).sum, in_degree_n(x, 3).sum, in_degree_n(x).sum],
             [in_degree_n(x, 5).sum, in_degree_n(x, 4).sum, in_degree_n(x, 3).sum],
             [in_degree_n(x, 6).sum, in_degree_n(x, 5).sum, in_degree_n(x, 4).sum]].det
    end

    def self.determinant_a(x, y)
      Matrix[[x_in_degree_n_on_y(x, y).sum - y.first*in_degree_n(x, 1).sum, in_degree_n(x, 3).sum, in_degree_n(x).sum],
             [x_in_degree_n_on_y(x, y, 2).sum - y.first*in_degree_n(x, 2).sum, in_degree_n(x, 4).sum, in_degree_n(x, 3).sum],
             [x_in_degree_n_on_y(x, y, 3).sum - y.first*in_degree_n(x, 3).sum, in_degree_n(x, 5).sum, in_degree_n(x, 4).sum]].det
    end

    def self.determinant_b(x, y)
      Matrix[[in_degree_n(x, 4).sum, x_in_degree_n_on_y(x, y).sum - y.first*in_degree_n(x, 1).sum, in_degree_n(x).sum],
             [in_degree_n(x, 5).sum, x_in_degree_n_on_y(x, y, 2).sum - y.first*in_degree_n(x, 2).sum, in_degree_n(x, 3).sum],
             [in_degree_n(x, 6).sum, x_in_degree_n_on_y(x, y, 3).sum - y.first*in_degree_n(x, 3).sum, in_degree_n(x, 4).sum]].det
    end

    def self.determinant_c(x, y)
      Matrix[[in_degree_n(x, 4).sum, in_degree_n(x, 3).sum, x_in_degree_n_on_y(x, y).sum - y.first*in_degree_n(x, 1).sum],
             [in_degree_n(x, 5).sum, in_degree_n(x, 4).sum, x_in_degree_n_on_y(x, y, 2).sum - y.first*in_degree_n(x, 2).sum],
             [in_degree_n(x, 6).sum, in_degree_n(x, 5).sum, x_in_degree_n_on_y(x, y, 3).sum - y.first*in_degree_n(x, 3).sum]].det
    end
  end
end
