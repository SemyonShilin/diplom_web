module Supports
  module Chart
    attr_accessor :chart

    def construct_line_chart
      Charts::Line.new do |line|
        line.title_chart = "#{self.class}"
        line.data = [{ name: "#{self.class} (из файла)", data: @options[:custom_coords] || coords, type: 'line' },
                     { name: "#{self.class} (approx)", data: process.approx_y, type: 'spline' }]
      end
    end

    private

    def coords
      Equations.calculate_points(@data_x, @data_y)
    end
  end
end