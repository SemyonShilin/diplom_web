class Information
  extend CarrierWave::Mount
  include ActiveModel::Model

  attr_accessor :excel, :header, :rows, :hash, :patient

  def initialize(options = {})
    @excel = options[:excel]
    @patient = options[:patient]
  end

  mount_uploader :excel, ExcelUploader

  def create
    data = ExcelDataParser.parse(self, @excel)
    pat = Patient.create!(name: @patient)

    ActiveRecord::Base.transaction do
      data.header.last.each do |gene|
        Gene.create!(name: gene)
      end

      DataX.create!(data.hash[data.header.last.first].map { |x| { percent: x, patient: pat } })

      data.header.last.each do |gene|
        g = Gene.find_by_name(gene)

        data.hash[gene].each_with_index do |y, index|
          record = DataY.new(percent: y)
          record.gene = g
          record.data_x = DataX.find_by_percent(data.rows[index][0])
          record.patient = pat
          record.save!
        end
      end
    end
    data
  end
end
