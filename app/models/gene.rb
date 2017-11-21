class Gene < ApplicationRecord
  has_many :data_ies
  has_many :real_data_ies
end
