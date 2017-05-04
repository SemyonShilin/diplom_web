# require 'mathn'
require 'nmatrix'

module ExcelDataParser
  def self.parse(file)
    workbook = RubyXL::Parser.parse(file.path)
    worksheet = workbook[0]
    cels=[]
    rows = []
    worksheet.each { |row|
      rows << row.cells.map(&:value)
      # temp =  row && row.cells
      # temp.map{|cell| cels << cell.value}
    }
    hash = {}
    hash[:header] = worksheet_header(rows).map{|t| t.map{|e| e.gsub(/ /, '_') }}
    # hash[:rows] = rows.sort_by! { |line| line[0] }
    hash[:rows] = average!(rows){ |line| line[0] }
    hash[:hash] = array_to_hash(hash[:header], hash[:rows])
    hash
  end

  private

  def self.worksheet_header(data)
    head = []
    data.each do |elem|
      elem[0].class == String ? head << elem : break
      # array_from_sheet.shift
    end
    head.size.times { data.shift }
    head
  end

  def self.average!(data, &block)
    data.sort_by! &block

    y = 1
    array_average = []
    # p vec = Vector[*data.at(0)]
    vec = NMatrix.new([data.at(0).size, 1], data.at(0), dtype: :float64)
    (data.size - 1).times do |index|
      if data[index][0] == data[index + 1][0]
        vec += NMatrix.new([data[index+1].size, 1], data[index+1], dtype: :float64)
        # vec += Vector[*data[index + 1]]
        y += 1
      else
        array_average << vec / y
        vec = NMatrix.new([data[index+1].size, 1], data[index+1], dtype: :float64)
        # vec = Vector[*data.at(index + 1)]
        y = 1
        next
      end
    end
    array_average << vec / y
    array_average.map! { |elem| elem.to_a.flatten } # .each{|elem| print "#{elem} \n"}
  end

  def self.array_to_hash(header, body)
    hash_from_array = {}
    0.upto(header.last.to_a.size - 1) do |index|
      hash_from_array[header[1][index]] = body.transpose[index]
    end
    hash_from_array
  end
end