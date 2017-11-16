class MNK::CubicParabola < MNK::Base
  def calculate_coefficients
    params = %w(a b c d)
    coefficients = []
    params.each do |p|
      coefficients << (send("determinant_#{p}", data_x, data_y) / general_determinant(data_x))
    end
    coefficients
  end

  private

  def general_determinant(x)
    Matrix[[in_degree_n(x, 3).sum, in_degree_n(x).sum, x.sum, x.size],
           [in_degree_n(x, 4).sum, in_degree_n(x, 3).sum, in_degree_n(x).sum, x.sum],
           [in_degree_n(x, 5).sum, in_degree_n(x, 4).sum, in_degree_n(x, 3).sum, in_degree_n(x).sum],
           [in_degree_n(x, 6).sum, in_degree_n(x, 5).sum, in_degree_n(x, 4).sum, in_degree_n(x, 3).sum]].det
  end

  def determinant_a(x, y)
    Matrix[[y.sum, in_degree_n(x).sum, x.sum, x.size],
           [x_in_degree_n_on_y(x, y).sum, in_degree_n(x, 3).sum, in_degree_n(x).sum, x.sum],
           [x_in_degree_n_on_y(x, y, 2).sum, in_degree_n(x, 4).sum, in_degree_n(x, 3).sum, in_degree_n(x).sum],
           [x_in_degree_n_on_y(x, y, 3).sum, in_degree_n(x, 5).sum, in_degree_n(x, 4).sum, in_degree_n(x, 3).sum]].det
  end

  def determinant_b(x, y)
    Matrix[[in_degree_n(x, 3).sum, y.sum, x.sum, x.size],
           [in_degree_n(x, 4).sum, x_in_degree_n_on_y(x, y).sum, in_degree_n(x).sum, x.sum],
           [in_degree_n(x, 5).sum, x_in_degree_n_on_y(x, y, 2).sum, in_degree_n(x, 3).sum, in_degree_n(x).sum],
           [in_degree_n(x, 6).sum, x_in_degree_n_on_y(x, y, 3).sum, in_degree_n(x, 4).sum, in_degree_n(x, 3).sum]].det
  end

  def determinant_c(x, y)
    Matrix[[in_degree_n(x, 3).sum, in_degree_n(x).sum, y.sum, x.size],
           [in_degree_n(x, 4).sum, in_degree_n(x, 3).sum, x_in_degree_n_on_y(x, y).sum, x.sum],
           [in_degree_n(x, 5).sum, in_degree_n(x, 4).sum, x_in_degree_n_on_y(x, y, 2).sum, in_degree_n(x).sum],
           [in_degree_n(x, 6).sum, in_degree_n(x, 5).sum, x_in_degree_n_on_y(x,y, 3).sum, in_degree_n(x, 3).sum]].det
  end

  def determinant_d(x, y)
    Matrix[[in_degree_n(x, 3).sum, in_degree_n(x).sum, x.sum, y.sum],
           [in_degree_n(x, 4).sum, in_degree_n(x, 3).sum, in_degree_n(x).sum, x_in_degree_n_on_y(x, y).sum],
           [in_degree_n(x, 5).sum, in_degree_n(x, 4).sum, in_degree_n(x, 3).sum, x_in_degree_n_on_y(x, y, 2).sum],
           [in_degree_n(x, 6).sum, in_degree_n(x, 5).sum, in_degree_n(x, 4).sum, x_in_degree_n_on_y(x, y, 3).sum]].det
  end

  def formule(x, coeff)
    a = coeff[0]#2.3055586981154643e-05
    b = coeff[1]#-0.0007970093314787948
    c = coeff[2]#0.6278312922935302
    d = coeff[3]#3.887052187887129
    a * x**3 + b * x**2 + c * x + d
  end
end
