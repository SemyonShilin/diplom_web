require 'mathn'
require 'matrix'
require 'nmatrix'

class MNK::Base
  include Supports::MNK

  attr_accessor :data_x, :data_y

  def initialize(**options)
    @data_x = options[:data_x]
    @data_y = options[:data_y]
  end

  def search_points(coeff, y)
    x_steps.map do |x|
      [x, formule(x, coeff)]
    end.bsearch { |x| x[1] >= y }[0]
  end

  private

  def x_steps
    temp = []
    0.step(by: 0.001, to: 100) { |elem| temp << elem }
    temp
  end
end