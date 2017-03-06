require 'mathn'
require 'matrix'

module MNK
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
