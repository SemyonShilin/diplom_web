require 'mathn'
require 'matrix'
require 'nmatrix'

class MNK::Base
  include Supports::MNK
  include Supports::Chart

  attr_accessor :data_x, :data_y, :approx_y, :coefficients, :min_max,
                :options

  def initialize(data_x:, data_y:, **options)
    @data_x = data_x
    @data_y = data_y
    @options = options
    @coefficients = calculate_coefficients
    @approx_y ||= process.approx_y
    @chart = construct_line_chart

    initialize_range
  end

  def search_points(coeff, y)
    initialize_range
    custom_search(coeff, y.to_f)
    @middle
  end

  def process
    @approx_y = "Equations::#{self.class.to_s.demodulize}".safe_constantize
                                                          .calculate_approximation_points(@data_x, @coefficients)
    @approx_y = @approx_y.each { |_, v| round_if_long_number(v) }
    self
  end

  private

  def custom_search(coeff, y)
    loop do
      break if @min_max.size == 1
      @min_max = y > formule(@middle, coeff) ? set_range(@middle, @min_max[-1]) : set_range(@min_max[0], @middle)
      @middle = median @min_max
    end
  end

  def initialize_range
    @min_max = (0.0..100.0).step(0.001).to_a
    @middle = median @min_max
  end

  def round_if_long_number(value)
    value.to_s.size > 17 ? "#{value}"[0..17].to_f : value
  end
end