class User < ApplicationRecord
  include Users::GroupedData

  has_many :documents
  has_many :data_ies, through: :documents
  has_many :data_xes, through: :documents
  has_many :real_data_ies, through: :documents
  has_many :genes, through: :data_ies
end
