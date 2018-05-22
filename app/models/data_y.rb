class DataY < ApplicationRecord
  belongs_to :gene
  belongs_to :data_x, optional: true
  belongs_to :user
  belongs_to :document
end
