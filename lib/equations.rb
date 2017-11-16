module Equations
  extend Supports::Plotting

  module CubicParabola
    extend Supports::Plotting

    def self.calculate_approximation_points(x, coefficients)
      x = x.collect(&:to_f)
      y = x.collect do |v|
        coefficients.first * v**3 + coefficients.second * v**2 + coefficients.third * v + coefficients.fourth
      end

      union_for_charts(x, y)
    end
  end

  module Hyperbola
    extend Supports::Plotting

    def self.calculate_approximation_points(x, coefficients)
      x = x.collect(&:to_f)
      y = x.collect do |v|
        (coefficients[0] * v + coefficients[1]) / (v + coefficients[2])
      end

      union_for_charts(x, y)
    end
  end

  def self.calculate_points(x, y)
    union_for_charts(x.map!(&:to_f), y.map!(&:to_f))
  end
end