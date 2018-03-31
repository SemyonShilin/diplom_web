class RealDataYController < ApplicationController
  respond_to :html, :js, :json

  # before_action :init_real_data_y, only: %i[new]
  before_action :init_data_y, only: %i[draw]
  before_action :init_global_option_chart, only: :draw

  def show
    @mnk = "MNK::#{allowed_chart_params[:chart].camelize}".safe_constantize
    @user = User.find_by_uid(session[:uid])

    data_x = @user.data_xes.where(document_id: session[:document_id]).order(:percent).distinct.pluck(:percent)
    real_data_x = @user.data_xes.where(document_id: session[:real_document_id]).order(:percent).distinct.pluck(:percent)
    data_y = @user.grouped_by_gene(session[:document_id])[params[:gene]]
    real_data_y = @user.grouped_by_gene_real_y_without_id(session[:real_document_id])[params[:gene]]

    coords = Equations.calculate_points(data_x, data_y)
    approx_coordinates = @mnk.new(data_x: real_data_x, data_y: real_data_y).process
    @coordinates = [{name: @mnk.to_s.demodulize, data: coords}, {name: "#{@mnk.to_s.demodulize} approx coordinates", data: approx_coordinates.approx_y}]#, { name: 'point', data: { y => 25 } }]
  end

  def new
    @information = Information.new({})
  end

  def create
    @information = Information.new(real_y_params)
    ParsingExcelJob.perform_now(@information.path, session[:uid], @information.real_y)
    pp session[:uid]
    pp @user = User.find_by_uid(session[:uid])
    # sleep 2

    session[:real_document_id] = @user.documents.last.id

    @data_x = @user.data_xes.order(:percent).distinct.pluck(:percent)
    @data_y = @user.grouped_by_gene_real_y( session[:real_document_id])

    render :create, layout: false
  end

  def search
    @user = User.find_by_uid(session[:uid])
    @data_x = @user.data_xes.order(:percent).distinct.pluck(:percent)
    @data_y = @user.grouped_by_gene(session[:document_id])#[params[:gene]]
    @mnk = "MNK::#{allowed_chart_params[:chart].camelize}".safe_constantize

    if params[:gene]
      coords = Equations.calculate_points(@data_x, @data_y[params[:gene]])
      object = @mnk.new(data_x: @data_x, data_y: @data_y[params[:gene]])
      approx_coordinates = object.process
      @coordinates = [{ name: @mnk.to_s.demodulize, data: coords }, { name: "#{@mnk.to_s.demodulize} approx coordinates", data: approx_coordinates.approx_y }]
    else
      approx_coordinates = {}
      coords = {}
      @coordinates = []
      @data_y.each do |gen, value|
        coords[gen] = Equations.calculate_points(@data_x, value)
        object = @mnk.new(data_x: @data_x, data_y: value)
        approx_coordinates[gen] = object.process
      end
    end

    real_x = {}
    needed_values = params[:gene] ? @user.grouped_by_gene_real_y_without_id_long(session[:real_document_id])[params[:gene]] : @user.grouped_by_gene_real_y_without_id_long(session[:real_document_id]).values
    gene_v = []
    needed_values.each_with_index do |data, index|
      data.shift unless params[:gene]
      real_x[index] = {}
      if params[:gene]
        key = object.search_points(object.coefficients, data) || 0
        real_x[index][key] ||= []
        real_x[index][key] << data

        real_x[index].reject! { |k, _| k == 0 }
        gene_v << temp = real_x[index].transform_values { |v| v&.at(0).to_f }.sort_by { |_, v| v }.to_h
      else
        data.each do |d|
          key = object.search_points(object.coefficients, d) || 0
          real_x[index][key] ||= []
          real_x[index][key] << d
        end
        real_x[index].reject! { |k, _| k == 0}
        temp = real_x[index].transform_values { |v| v&.at(0).to_f }.sort_by { |_, v| v }.to_h
        @coordinates.push({ name: (index + 1).to_s, data: temp })
      end
    end
    @coordinates.push({ name: 1, data: gene_v.map { |h| h.to_a.flatten } }) if params[:gene]

    render :search, layout: false
  end

  def draw
    coords = Equations.calculate_points(@data_x, @data_y)

    approx_coordinates_cub_p = MNK::CubicParabola.new(data_x: @data_x, data_y: @data_y).process
    # y = parabola.search_points(@coefficients_cub_p, 25)
    @coordinates_cub_p = [{ name: 'cub_p', data: coords }, { name: 'cub_p approx coordinates', data: approx_coordinates_cub_p.approx_y }]#, { name: 'point', data: { y => 25 } }]

    approx_coordinates_hyp = MNK::Hyperbola.new(data_x: @data_x, data_y: @data_y).process
    @coordinates_hyp = [{name: 'hyp', data: coords}, {name: 'hyp approx coordinates', data: approx_coordinates_hyp.approx_y}]

    approx_coordinates_cub_p_e = MNK::CubicParabolaWithExtremes.new(data_x: @data_x, data_y: @data_y).process
    @coordinates_cub_p_e = [{name: 'cub_p_e', data: coords}, {name: 'cub_p_e approx coordinates', data: approx_coordinates_cub_p_e.approx_y}]

    approx_data_hash = { cub_p: approx_coordinates_cub_p.approx_y.values, cub_p_e: approx_coordinates_cub_p_e.approx_y.values, hyp: approx_coordinates_hyp.approx_y.values }
    @mist = Supports::Mistake.calculate(@data_y, approx_data_hash)
    # @meta = MetaModel.new()
    @chart = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(text: "Population vs GDP For 5 Big Countries [2009]")
      # f.xAxis(categories: ["United States", "Japan", "China", "Germany", "France"])
      f.series(name: @coordinates_cub_p.first[:name], yAxis: 0, data: @coordinates_cub_p.first[:data].to_a, type: 'line')
      f.series(name: @coordinates_cub_p.second[:name], yAxis: 1, data: @coordinates_cub_p.second[:data].to_a, type: 'spline')

      f.yAxis [
                {title: {text: "GDP in Billions", margin: 70} },
                {title: {text: "approx"}, visible: false}
              ]

      f.legend(align: 'center', verticalAlign: 'bottom', y: 75, x: -50, layout: 'vertical')
    end
  end

  private

  def allowed_chart_params
    allowed_chart = %w(cubic_parabola cubic_parabola_with_extremes hyperbola)
    params.permit(:uid, :gene, :chart, :real_id, :all)
    params.delete(:chart) unless params[:chart].in? allowed_chart
    params
  end

  def init_real_data_y
    @user = User.find_by_uid(session[:uid])
    @data_x = @user.data_xes.where(document_id: session[:real_document_id]).order(:percent).distinct.pluck(:percent)
    data_y = @user.grouped_by_gene_real_y_without_id(session[:real_document_id])
    @data_y = action_name == 'all' ? data_y.values : data_y[params[:gene]]
  end

  def init_data_y
    @user = User.includes(:data_xes, :data_ies, :genes).find_by_uid(session[:uid])
    @data_x = @user.data_xes.where(document_id: session[:document_id]).order(:percent).distinct.pluck(:percent)
    data_y = @user.grouped_by_gene(session[:document_id])
    @data_y = action_name == 'all' ? data_y.values : data_y[params[:gene]]
  end

  def real_y_params
    params.require(:information).permit(:real_y, :excel, :uid, :remotipart_submitted, :authenticity_token, :'X-Requested-With', :'X-Http-Accept')
  end

  def init_global_option_chart
    @chart_globals = LazyHighCharts::HighChartGlobals.new do |f|
      f.global(useUTC: false)
      f.chart(
        width: 700
      )
      f.lang(
        loading: 'Загрузка...',
        months: ['Январь', 'Февраль', 'Март', 'Апрель', 'Май', 'Июнь', 'Июль', 'Август', 'Сентябрь', 'Октябрь', 'Ноябрь', 'Декабрь'],
        weekdays: ['Воскресенье', 'Понедельник', 'Вторник', 'Среда', 'Четверг', 'Пятница', 'Суббота'],
        shortMonths: ['Янв', 'Фев', 'Март', 'Апр', 'Май', 'Июнь', 'Июль', 'Авг', 'Сент', 'Окт', 'Нояб', 'Дек'],
        exportButtonTitle: "Экспорт",
        printButtonTitle: "Печать",
        rangeSelectorFrom: "С",
        rangeSelectorTo: "По",
        rangeSelectorZoom: "Период",
        downloadPNG: 'Скачать PNG',
        downloadJPEG: 'Скачать JPEG',
        downloadPDF: 'Скачать PDF',
        downloadSVG: 'Скачать SVG',
        printChart: 'Напечатать график')
    end
  end
end
