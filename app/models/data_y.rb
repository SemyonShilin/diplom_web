class DataY < ApplicationRecord
  belongs_to :gene
  belongs_to :data_x
  belongs_to :patient
end
