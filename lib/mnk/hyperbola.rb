class MNK::Hyperbola < MNK::Base
  def calculate_coefficients
    params = %w(a b d)
    coefficients = []
    params.each do |p|
      coefficients << send("coefficient_#{p}", data_x, data_y)
    end
    coefficients
  end

  def coefficient_a(x, y)
    (x.last*y.last + (y.last-y.first)*coefficient_d(x, y))/x.last
  end

  def coefficient_b(x, y)
    y.first*coefficient_d(x, y)
  end

  def coefficient_d(x, y)
    -(determinant_k2(x, y) / general_determinant(x, y))
  end

  private

  def general_determinant(x, y)
    Matrix[[in_degree_n(x).sum, in_degree_n(x, 1).sum, x_in_degree_n_on_y(x, y).sum],
           [x_in_degree_n_on_y(x, y).sum, in_degree_n(y, 1).sum, in_degree_n(y).sum],
           [in_degree_n(x, 1).sum, in_degree_n(y, 1).sum, x.size]].det
  end

  def determinant_k1(x, y)
    Matrix[[x_in_degree_n_on_y(x, y, 2).sum, in_degree_n(x, 1).sum, x_in_degree_n_on_y(x, y)],
           [mult(x_in_degree_n_on_y(x, y), in_degree_n(y, 1)).sum, in_degree_n(y, 1).sum, in_degree_n(y).sum],
           [x_in_degree_n_on_y(x, y).sum, in_degree_n(y, 1).sum, x.size]].det
  end

  def determinant_k2(x, y)
    Matrix[[in_degree_n(x).sum, x_in_degree_n_on_y(x, y, 2).sum, x_in_degree_n_on_y(x, y).sum],
           [x_in_degree_n_on_y(x, y).sum, mult(x_in_degree_n_on_y(x, y), in_degree_n(y, 1)).sum, in_degree_n(y).sum],
           [in_degree_n(x, 1).sum, x_in_degree_n_on_y(x, y).sum, x.size]].det
  end

  def determinant_k3(x, y)
    Matrix[[in_degree_n(x).sum, in_degree_n(x, 1).sum, x_in_degree_n_on_y(x, y, 2).sum],
           [x_in_degree_n_on_y(x, y).sum, in_degree_n(y, 1).sum, mult(x_in_degree_n_on_y(x, y), in_degree_n(y, 1)).sum],
           [in_degree_n(x, 1).sum, in_degree_n(y, 1).sum, x_in_degree_n_on_y(x, y).sum]].det
  end

  def formule(x, coeff)
    a = coeff[0]#2.3055586981154643e-05
    b = coeff[1]#-0.0007970093314787948
    c = coeff[2]#0.6278312922935302
    (a * x + b) / (x + c)
  end
end