module Charts
  class Line < LazyHighCharts::HighChart
    attr_accessor :kind, :title_chart, :name, :data

    def initialize(**options)
      @@canvas = 'graph'
      super
      build_chart
    end

    def build_chart
      tap do |line|
        line.title(text: line.title_chart)
        line.data.each do |hash|
          line.series(name: hash[:name],
                      yAxis: 0,
                      data: deep_to_f(hash[:data]),
                      type: hash[:type])
        end

        line.yAxis [{ max: 100, title: { text: 'Y', margin: 70 }, visible: true }]

        line.legend(align: 'center', verticalAlign: 'bottom',
                    layout: 'vertical')
      end
    end

    private

    def deep_to_f(array)
      array.to_a.map { |a| a.map(&:to_f) }
    end
  end

  class Column < LazyHighCharts::HighChart
    attr_accessor :kind, :title_chart, :name, :data

    def initialize(**options)
      @@canvas = 'graph'
      super
      build_chart
    end

    def build_chart
      tap do |line|
        line.title(text: line.title_chart)
        line.data.each do |hash|
          line.series(name: hash[:name],
                      yAxis: 0,
                      data: [hash[:data]],
                      type: hash[:type] || 'column')
        end
        line.yAxis [{ title: { text: 'Y', margin: 70 }, visible: true }]

        line.legend(align: 'center', verticalAlign: 'bottom',
                    layout: 'vertical')
      end
    end
  end
end