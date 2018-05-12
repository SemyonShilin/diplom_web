module ExcelTemplateBuilder
  class << self
    def build(data)
      workbook = RubyXL::Workbook.new
      worksheet = workbook[0]
      worksheet.sheet_name = 'Исправленные данные'
      data.each_with_index { |gen, index| worksheet.add_cell(0, index, index == 0 ? 'X' : gen[:name]) }
      data.last[:data].each_with_index { |x, index| worksheet.add_cell(index + 1, 0, x.first) }
      data[1..-1].each_with_index do |gen, column|
        gen[:data].map(&:last).each_with_index do |y, row|
          worksheet.add_cell(row + 1, column + 1, y)
        end
      end
      name = ('a'..'z').to_a.shuffle[0,8].join
      workbook.write("public/excel/#{name}.xlsx")
      "/excel/#{name}.xlsx"
    end
  end
end