module Users::GroupedData
  extend ActiveSupport::Concern

  included do
    def grouped_by_gene(document_id)
      grouped = ActiveSupport::HashWithIndifferentAccess.new
      data_ies.includes(:gene).where(document_id: document_id).group_by { |y| y.gene.name }.each do |gene, y|
        grouped[gene] = y.sort_by(&:percent).pluck(:percent)
      end

      grouped
    end

    def grouped_by_gene_real_y(document_id)
      grouped = ActiveSupport::HashWithIndifferentAccess.new
                  # .where('created_at > ?', Time.now - 0.1.minute)
      real_data_ies.includes(:gene).where(document_id: document_id).group_by { |y| y.gene.name }.each do |gene, y|
        grouped[gene] = y.uniq.pluck(:id, :percent, :patient_name)
      end

      grouped
    end

    def grouped_by_gene_real_y_without_id(document_id)
      grouped = ActiveSupport::HashWithIndifferentAccess.new
                  # .where('created_at > ?', Time.now - 0.1.minute)
      real_data_ies.includes(:gene).where(document_id: document_id).group_by { |y| y.gene.name }.each do |gene, y|
        grouped[gene] = y.uniq.pluck(:percent)
      end

      grouped
    end

    def grouped_by_gene_real_y_without_id_long(document_id)
      grouped = ActiveSupport::HashWithIndifferentAccess.new
                  # .where('created_at > ?', Time.now - 0.5.minute)
      real_data_ies.includes(:gene).where(document_id: document_id).group_by { |y| y.gene.name }.each do |gene, y|
        grouped[gene] = y.uniq.pluck(:percent, :patient_name)
      end

      grouped
    end
  end
end
