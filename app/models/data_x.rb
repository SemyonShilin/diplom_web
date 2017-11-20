class DataX < ApplicationRecord
  has_many :data_ies
  belongs_to :patient
end
