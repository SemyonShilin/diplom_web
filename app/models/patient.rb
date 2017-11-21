class Patient < ApplicationRecord
  has_many :data_ies
  has_many :data_xes
  has_many :real_data_ies
  has_many :genes, through: :data_ies


  def grouped_by_gene
    grouped = ActiveSupport::HashWithIndifferentAccess.new
    data_ies.group_by { |y| y.gene.name }.each do |gene, y|
      grouped[gene] = y.pluck(:percent)
    end

    grouped
  end
end
