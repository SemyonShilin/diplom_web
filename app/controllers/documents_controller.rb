class DocumentsController < ApplicationController
  respond_to :html, :js, :json

  def index
    collection = Document.includes(:data_ies).where.not(data_ies: { document_id: nil }).order(:id)
    collection_real_data = Document.includes(:real_data_ies).where.not(real_data_ies: { document_id: nil }).order(:id)
    @collection = []
    collection_real_data.map.with_index do |crd, index|
      @collection << [collection[index]&.id, crd&.id]
    end
  end

  def set_document
    unless params[:id] == nil
      session[:document_id] = params[:id].to_i
    end
    redirect_to all_information_index_path
  end

  def set_real_document
    unless params[:id] == nil
      session[:real_document_id] = params[:id].to_i
    end
    redirect_to real_data_y_index_path
  end
end
