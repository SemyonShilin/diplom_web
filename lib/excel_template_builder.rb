module ExcelTemplateBuilder
  class << self
    def build(data)
      workbook = RubyXL::Workbook.new
      worksheet = workbook[0]
      worksheet.sheet_name = 'Исправленные данные'
      data.each_with_index { |gen, index| worksheet.add_cell(0, index, gen[:name]) }
      data[0..-1].each_with_index do |gen, column|
        gen[:data].each_with_index do |y, row|
          worksheet.add_cell(row + 1, column, y)
        end
      end
      name = ('a'..'z').to_a.shuffle[0,8].join
      workbook.write("public/excel/#{name}.xlsx")
      "/excel/#{name}.xlsx"
    end
  end
end