class RealDataYController < ApplicationController
  respond_to :html, :js, :json

  before_action :init_user
  # before_action :init_real_data_y, only: %i[new]
  before_action :init_data_y, only: %i[show draw]

  def index
    @data_x = @user.data_xes.order(:percent).distinct.pluck(:percent)
    @data_y = @user.grouped_by_gene_real_y(session[:real_document_id])

    render
  end

  def show
    @mnk = "MNK::#{allowed_chart_params[:chart].camelize}".safe_constantize
    @coordinates = @mnk.new(data_x: @data_x, data_y: @data_y)
  end

  def new
    @information = Information.new({})
  end

  def create
    @information = Information.new(real_y_params)
    params = { path: @information.path, uid: session[:uid], real_y:  @information.real_y, name: @information.name}
    Information.new(params).create
    # ParsingExcelJob.perform_now(@information.path, session[:uid], @information.real_y)

    session[:real_document_id] = @user.documents.last.id

    @data_x = @user.data_xes.order(:percent).distinct.pluck(:percent)
    @data_y = @user.grouped_by_gene_real_y(session[:real_document_id])

    render :create, layout: false
  end

  def draw
    @coordinates_cub_p = MNK::CubicParabola.new(data_x: @data_x, data_y: @data_y)
    @coordinates_hyp = MNK::Hyperbola.new(data_x: @data_x, data_y: @data_y)
    @coordinates_cub_p_e = MNK::CubicParabolaWithExtremes.new(data_x: @data_x, data_y: @data_y)

    approx_data_hash = { cub_p: @coordinates_cub_p.approx_y.values, cub_p_e: @coordinates_hyp.approx_y.values, hyp: @coordinates_cub_p_e.approx_y.values }
    @mist = Supports::Mistake.chart(@data_y, approx_data_hash)
  end

  def search
    @data_x = @user.data_xes.order(:percent).distinct.pluck(:percent)
    @data_y = @user.grouped_by_gene(session[:document_id])#[params[:gene]]
    @mnk = "MNK::#{allowed_chart_params[:chart].camelize}".safe_constantize
    @real_data_x = @data_x
    @fixed = []

    grouped_values = @user.grouped_by_gene_real_y_without_id_long(session[:real_document_id])
    needed_values = params[:gene] ? grouped_values[params[:gene]] : grouped_values.values[1..-1]
    gene_v = []
    gene_name = @data_y.keys

    patients = grouped_values.select { |k, _| k unless k.start_with?('CG') }.transform_values { |v| v.map(&:second) }
    @fixed.push({ name: patients.keys.first, data: patients.values.first })

    needed_values.each_with_index do |data, index|
      data.unshift unless params[:gene]
      if params[:gene]
        next if data[0] == nil

        object = @mnk.new(data_x: @data_x, data_y: @data_y[params[:gene]])
        gene_v[index] = (object.search_points(object.coefficients, data[0]) || 0)&.to_f
      else
        object = @mnk.new(data_x: @data_x, data_y: @data_y[gene_name[index + 1]])
        searched = []

        data.each_with_index  do |d, i|
          next if d[0] == nil
          searched[i] = (object.search_points(object.coefficients, d[0]) || 0)&.to_f
        end
        @fixed.push({ name: gene_name[index + 1].to_s, data: searched })
      end

    end

    @fixed.push({ name: params[:gene], data: gene_v})if params[:gene]
    @file = ExcelTemplateBuilder.build(@fixed)

    render :search, layout: false
  end

  private

  def allowed_chart_params
    allowed_chart = %w(cubic_parabola cubic_parabola_with_extremes hyperbola)
    params.permit(:uid, :gene, :chart, :real_id, :all, :current_gene)
    params.delete(:chart) unless params[:chart].in? allowed_chart
    params
  end

  def init_real_data_y
    @user = User.all.first
    @data_x = @user.data_xes.where(document_id: session[:real_document_id]).order(:percent).distinct.pluck(:percent)
    data_y = @user.grouped_by_gene_real_y_without_id(session[:real_document_id])
    @data_y = action_name == 'all' ? data_y.values : data_y[params[:gene]]
  end

  def init_data_y
    # @user = User.includes(:data_xes, :data_ies, :genes).find_by_uid(session[:uid])
    @data_x = @user.data_xes.where(document_id: session[:document_id]).order(:percent).distinct.pluck(:percent)
    data_y = @user.grouped_by_gene(session[:document_id])
    @data_y = action_name == 'all' ? data_y.values : data_y[params[:gene]]
  end

  def real_y_params
    params.require(:information).permit(:real_y, :excel, :uid, :remotipart_submitted, :authenticity_token, :'X-Requested-With', :'X-Http-Accept')
  end

  def init_user
    @user = User.includes(:data_xes, :data_ies, :genes).all.first
  end
end
