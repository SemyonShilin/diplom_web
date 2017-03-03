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
end
