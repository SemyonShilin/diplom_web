module RealDataYHelper
  def search_chart(data)
    Charts::Line.new do |line|
      line.title_chart = "Поиск"
      line.data = data
    end
  end
end
