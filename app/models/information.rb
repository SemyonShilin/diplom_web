class Information
  extend CarrierWave::Mount
  include ActiveModel::Model

  attr_accessor :excel

  mount_uploader :excel, ExcelUploader
end
