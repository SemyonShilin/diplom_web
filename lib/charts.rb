module Charts
  class Line < LazyHighCharts::HighChart
    attr_accessor :kind, :title_chart, :name, :data, :approximation_name, :approximation_data

    def initialize(**options)
      @@canvas = 'graph'
      super
      build_chart
    end

    def build_chart
      self.tap do |line|
        line.title(text: line.title_chart)
        # f.xAxis(categories: ["United States", "Japan", "China", "Germany", "France"])
        line.series(name: line.name,
                    yAxis: 0,
                    data: line.data.to_a, type: 'line')
        line.series(name: line.approximation_name,
                    yAxis: 1,
                    data: line.approximation_data.to_a, type: 'spline')

        line.yAxis [{ max: 100, title: { text: 'Y', margin: 70 } },
                    { max: 100, title: { text: 'approx' }, visible: false }]

        line.legend(align: 'center', verticalAlign: 'bottom',
                    y: 75, x: -50, layout: 'vertical')
      end
    end
  end

  class Column < LazyHighCharts::HighChart
  end
end