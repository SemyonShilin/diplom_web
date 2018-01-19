class Document < ApplicationRecord
  belongs_to :user
  has_many :data_ies
  has_many :data_xes
  has_many :real_data_ies
end
