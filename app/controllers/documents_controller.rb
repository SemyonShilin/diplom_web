class DocumentsController < ApplicationController
  respond_to :html, :js, :json

  before_action :redirect_if_document_blank, only: :set_real_document,
                unless: -> { session[:document_id].present? }

  def index
    collection = Document.includes(:data_ies).where.not(data_ies: { document_id: nil }).order(:id)
    collection_real_data = Document.includes(:real_data_ies).where.not(real_data_ies: { document_id: nil }).order(:id)
    @collection = []
    collection_real_data.map.with_index do |crd, index|
      @collection << [{ name: collection[index]&.name, id: collection[index]&.id },
                      { name: crd&.name, id: crd&.id }]
    end
  end

  def set_document
    if params[:id].present?
      session[:document_id] = params[:id].to_i
    end
    flash[:notice] = 'Вы успешно выбрали файл с калибровочными данными'
    redirect_to all_information_index_path
  end

  def set_real_document
    if params[:id].present?
      session[:real_document_id] = params[:id].to_i
    end
    flash[:notice] = 'Вы успешно выбрали файл с экспериментальными данными'
    redirect_to real_data_y_index_path
  end

  private

  def redirect_if_document_blank
    flash[:notice] = 'Пожалуйста, сначала выберете калибровочные данные'
    redirect_back fallback_location: :index
  end
end
