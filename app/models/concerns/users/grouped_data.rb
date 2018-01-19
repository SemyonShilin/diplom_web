module Users::GroupedData
  extend ActiveSupport::Concern

  included do
    def grouped_by_gene
      grouped = ActiveSupport::HashWithIndifferentAccess.new
      data_ies.group_by { |y| y.gene.name }.each do |gene, y|
        grouped[gene] = y.sort_by(&:percent).pluck(:percent)
      end

      grouped
    end

    def grouped_by_gene_real_y
      grouped = ActiveSupport::HashWithIndifferentAccess.new
      real_data_ies.where('created_at > ?', DateTime.now - 0.1.minute).group_by { |y| y.gene.name }.each do |gene, y|
        grouped[gene] = y.sort_by(&:percent).uniq.pluck(:id, :percent)
      end

      grouped
    end

    def grouped_by_gene_real_y_without_id
      grouped = ActiveSupport::HashWithIndifferentAccess.new
      real_data_ies.where('created_at > ?', DateTime.now - 0.1.minute).group_by { |y| y.gene.name }.each do |gene, y|
        grouped[gene] = y.sort_by(&:percent).uniq.pluck(:percent)
      end

      grouped
    end

    def grouped_by_gene_real_y_without_id_long
      grouped = ActiveSupport::HashWithIndifferentAccess.new
      real_data_ies.where('created_at > ?', DateTime.now - 0.5.minute).group_by { |y| y.gene.name }.each do |gene, y|
        grouped[gene] = y.sort_by(&:percent).uniq.pluck(:percent)
      end

      grouped
    end
  end
end
