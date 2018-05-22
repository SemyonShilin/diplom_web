class Information
  extend CarrierWave::Mount
  include ActiveModel::Model

  attr_accessor :excel, :header, :rows, :hash, :uid, :real_y, :path, :name

  def initialize(options = {})
    @excel = options[:excel]
    @uid = options[:uid]
    @real_y = serialize_real_y(options[:real_y])
    @path = options[:path] || @excel&.path
    @name = options[:name] || @excel&.original_filename
  end

  mount_uploader :excel, ExcelUploader

  def create
    data = ExcelDataParser.parse(self, @path, @excel)
    user = User.all.first
    document = user.documents.create!(user: user, name: @name)

    model = @real_y ? RealDataY : DataY

    ActiveRecord::Base.transaction do
      data.header.last.each do |gene|
        Gene.create!(name: gene, document: document)
      end

      unless @real_y
        DataX.create!(data.hash[data.header.last.first].map { |x| { percent: x, user: user, document: document } })
      end

      data.header.last.each do |gene|
        g = Gene.find_by_name(gene)

        data.hash[gene].each_with_index do |y, index|
          record = y.is_a?(String) ? model.new(patient_name: y) : model.new(percent: y)
          record.gene = g
          unless data.rows[index][0].is_a?(String)
            record.data_x = DataX.find_by_percent(data.rows[index][0])
          end
          record.user = user
          record.document = document
          record.save!
        end
      end
    end
    data
  end

  def serialize_real_y(real_y)
    return true if real_y.is_a? TrueClass
    real_y == 'true' ? true : false
  end
end
