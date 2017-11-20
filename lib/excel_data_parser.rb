# require 'mathn'
require 'nmatrix'

module ExcelDataParser
  class << self
    def parse(information, file)
      workbook = RubyXL::Parser.parse(file.path)
      worksheet = workbook[0]
      rows = []
      worksheet.each { |row| rows << row.cells.map(&:value) }
      information.header = worksheet_header(rows).map { |t| t.map { |e| e.gsub(/ /, '_') } }
      information.rows = average!(rows) { |line| line[0] }
      information.hash = array_to_hash(information.header, information.rows)
      information
    end

    private

    def worksheet_header(data)
      head = []
      data.each { |elem| elem[0].class == String ? head << elem : break }
      head.size.times { data.shift }
      head
    end

    def average!(data, &block)
      data.sort_by! &block

      y = 1
      array_average = []
      vec = NMatrix.new([data.at(0).size, 1], data.at(0), dtype: :float64)
      (data.size - 1).times do |index|
        if data[index][0] == data[index + 1][0]
          vec += NMatrix.new([data[index + 1].size, 1], data[index + 1], dtype: :float64)
          y += 1
        else
          array_average << vec / y
          vec = NMatrix.new([data[index + 1].size, 1], data[index + 1], dtype: :float64)
          y = 1
          next
        end
      end
      array_average << vec / y
      array_average.map! { |elem| elem.to_a.flatten }
    end

    def array_to_hash(header, body)
      hash_from_array = {}
      0.upto(header.last.to_a.size - 1) do |index|
        hash_from_array[header[1][index]] = body.transpose[index]
      end
      hash_from_array
    end
  end
end