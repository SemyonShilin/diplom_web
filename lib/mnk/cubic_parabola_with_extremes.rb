require 'mathn'
require 'matrix'
require 'nmatrix'
# require 'linefit'
# require 'binary_search/native'

module MNK::CubicParabolaWithExtremes
  extend Supports::MNK

  class << self
    def calculate_coefficients(x, y)
      coefficients = []
      params = %w(a b c d)

      params.each do |p|
        coefficients << send("coefficient_#{p}", x, y)
      end
      coefficients
    end

    def coefficient_a(x, y)
      determinant_a(x, y) / general_determinant(x)
    end

    def coefficient_b(x, y)
      determinant_b(x, y) / general_determinant(x)
    end

    def coefficient_c(x, y)
      (y.last - coefficient_a(x, y) * x.last**3 - coefficient_b(x, y) * x.last**2 - y.first)/x.last
    end

    def coefficient_d(x, y)
      y.first
    end

    private

    def general_determinant(x)
      Matrix[[in_degree_n(x, 4).sum, in_degree_n(x, 3).sum, in_degree_n(x).sum],
             [in_degree_n(x, 5).sum, in_degree_n(x, 4).sum, in_degree_n(x, 3).sum],
             [in_degree_n(x, 6).sum, in_degree_n(x, 5).sum, in_degree_n(x, 4).sum]].det
    end

    def determinant_a(x, y)
      Matrix[[x_in_degree_n_on_y(x, y).sum - y.first*in_degree_n(x, 1).sum, in_degree_n(x, 3).sum, in_degree_n(x).sum],
             [x_in_degree_n_on_y(x, y, 2).sum - y.first*in_degree_n(x, 2).sum, in_degree_n(x, 4).sum, in_degree_n(x, 3).sum],
             [x_in_degree_n_on_y(x, y, 3).sum - y.first*in_degree_n(x, 3).sum, in_degree_n(x, 5).sum, in_degree_n(x, 4).sum]].det
    end

    def determinant_b(x, y)
      Matrix[[in_degree_n(x, 4).sum, x_in_degree_n_on_y(x, y).sum - y.first*in_degree_n(x, 1).sum, in_degree_n(x).sum],
             [in_degree_n(x, 5).sum, x_in_degree_n_on_y(x, y, 2).sum - y.first*in_degree_n(x, 2).sum, in_degree_n(x, 3).sum],
             [in_degree_n(x, 6).sum, x_in_degree_n_on_y(x, y, 3).sum - y.first*in_degree_n(x, 3).sum, in_degree_n(x, 4).sum]].det
    end

    def determinant_c(x, y)
      Matrix[[in_degree_n(x, 4).sum, in_degree_n(x, 3).sum, x_in_degree_n_on_y(x, y).sum - y.first*in_degree_n(x, 1).sum],
             [in_degree_n(x, 5).sum, in_degree_n(x, 4).sum, x_in_degree_n_on_y(x, y, 2).sum - y.first*in_degree_n(x, 2).sum],
             [in_degree_n(x, 6).sum, in_degree_n(x, 5).sum, x_in_degree_n_on_y(x, y, 3).sum - y.first*in_degree_n(x, 3).sum]].det
    end
  end
end