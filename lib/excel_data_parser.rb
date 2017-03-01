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
    rows
  end

  def self.worksheet_header(data)
    head = []
    data.each do |elem|
      elem[0].class == String ? head << elem : break
      # array_from_sheet.shift
    end
    head.size.times { data.shift }
    head
  end

  def sort_array!
    self.sort_by! { |line| line[0] }
    # array_from_sheet.each{|elem| print "#{elem}\n"}
  end

  def average!
    y = 1
    array_average = []
    vec = Vector[*self.at(0)]
    (self.size - 1).times do |index|
      if self[index][0] == self[index + 1][0]
        vec += Vector[*self[index + 1]]
        y += 1
      else
        array_average << vec / y
        vec = Vector[*self.at(index + 1)]
        y = 1
        next
      end
    end
    array_average << vec / y
    array_average.map! { |elem| elem.to_a } # .each{|elem| print "#{elem} \n"}
  end

  # def array_to_hash
  #   0.upto(array_head.last.to_a.size - 1) do |index|
  #     @hash_from_array[array_head[1][index]] = array_average.transpose[index]
  #   end
  #   hash_from_array
  # end
end