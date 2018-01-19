class RealDataY < ApplicationRecord
  belongs_to :gene
  belongs_to :data_x
  belongs_to :user
  belongs_to :document
end
