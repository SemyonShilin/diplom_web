class RealDataYController < ApplicationController
  respond_to :html, :js, :json

  before_action :init_user
  # before_action :init_real_data_y, only: %i[new]
  before_action :init_data_y, only: %i[draw]

  def index
    @data_x = @user.data_xes.order(:percent).distinct.pluck(:percent)
    pp @data_y = @user.grouped_by_gene_real_y(session[:real_document_id])
    pp session[:real_document_id]
    render
  end

  def show
    @mnk = "MNK::#{allowed_chart_params[:chart].camelize}".safe_constantize

    data_x = @user.data_xes.where(document_id: session[:document_id]).order(:percent).distinct.pluck(:percent)
    real_data_x = @user.data_xes.where(document_id: session[:real_document_id]).order(:percent).distinct.pluck(:percent)
    data_y = @user.grouped_by_gene(session[:document_id])[params[:gene]]
    real_data_y = @user.grouped_by_gene_real_y_without_id(session[:real_document_id])[params[:gene]]

    @coordinates = @mnk.new(data_x: real_data_x, data_y: real_data_y,
                            custom_coords: Equations.calculate_points(data_x, data_y))
  end

  def new
    @information = Information.new({})
  end

  def create
    @information = Information.new(real_y_params)
    params = { path: @information.path, uid: session[:uid], real_y:  @information.real_y}
    Information.new(params).create
    # ParsingExcelJob.perform_now(@information.path, session[:uid], @information.real_y)
    # sleep 2

    session[:real_document_id] = @user.documents.last.id

    @data_x = @user.data_xes.order(:percent).distinct.pluck(:percent)
    @data_y = @user.grouped_by_gene_real_y( session[:real_document_id])

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
    @real_data_x = @user.data_xes.where(document_id: session[:real_document_id]).order(:percent).distinct.pluck(:percent)
    coords = Equations.calculate_points(@data_x, @data_y[params[:gene] || params[:current_gene]])
    @coordinates = [{ name: @mnk.to_s.demodulize, data: coords, type: 'line' }]

    real_x = {}
    needed_values = params[:gene] ? @user.grouped_by_gene_real_y_without_id_long(session[:real_document_id])[params[:gene]] : @user.grouped_by_gene_real_y_without_id_long(session[:real_document_id]).values
    gene_v = []
    gene_name = @data_y.keys

    needed_values[1..-1].each_with_index do |data, index|
      data.unshift unless params[:gene]
      real_x[index] = {}
      if params[:gene]
        object = @mnk.new(data_x: @data_x, data_y: @data_y[params[:gene]])
        real_x[index][@real_data_x[index]] ||= []
        real_x[index][@real_data_x[index]] << object.search_points(object.coefficients, data) || 0

        real_x[index].reject! { |k, _| k.nil? }
        gene_v << real_x[index].transform_values { |v| v&.at(0).to_f }.sort_by(&:last)
      else
        object = @mnk.new(data_x: @data_x, data_y: data)
        searched = []
        data.each_with_index  do |d, _|
          searched << object.search_points(object.coefficients, d) || 0
        end
        temp = Equations.calculate_points(@real_data_x, searched).sort_by(&:last)
        @coordinates.push({ name: gene_name[index + 1].to_s, data: temp, type: 'spline' })
      end
    end
    @coordinates.push({ name: params[:gene], data: gene_v.map { |h| h.to_a.flatten }, type: 'spline'}) if params[:gene]
    @file = ExcelTemplateBuilder.build(@coordinates)

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
