class DataX < ApplicationRecord
  has_many :data_ies
  has_many :real_data_ies
  belongs_to :patient
end
