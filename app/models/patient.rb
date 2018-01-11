class Patient < ApplicationRecord
  include Patients::GroupedData

  has_many :data_ies
  has_many :data_xes
  has_many :real_data_ies
  has_many :genes, through: :data_ies
end
