module Supports
  module Chart
    def construct_line_chart
      Charts::Line.new do |line|
        line.title_chart = "#{self.class}"
        line.name = "#{self.class}(данные из файла)"
        line.data = coords
        line.approximation_name = "#{self.class} approx coordinates"
        line.approximation_data = process.approx_y
      end
    end

    # def construct_column_chart
    #
    # end

    private

    def coords
      Equations.calculate_points(@data_x, @data_y)
    end
  end
end