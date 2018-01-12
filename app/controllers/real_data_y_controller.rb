class RealDataYController < ApplicationController
  respond_to :html, :js, :json
  before_action :init_data, only: %i[show]

  def show
    @information = Information.new({})

    coords = Equations.calculate_points(@data_x, @data_y)
    @mnk = "MNK::#{allowed_chart_params[:chart].camelize}".safe_constantize
    approx_coordinates = @mnk.new(data_x: @data_x, data_y: @data_y).process
    @coordinates = [{name: @mnk.to_s.demodulize, data: coords}, {name: "#{@mnk.to_s.demodulize} approx coordinates", data: approx_coordinates.approx_y}]#, { name: 'point', data: { y => 25 } }]
  end

  def create
    @information = Information.new(real_y_params)
    ParsingExcelJob.perform_later(@information.path, session[:uid])

    @patient = Patient.find_by_uid(session[:uid])
    @data_x = @patient.data_xes.order(:percent).distinct.pluck(:percent)
    @data_y = @patient.grouped_by_gene_real_y.values

    render :create, layout: false
  end

  def search
    @patient = Patient.find_by_uid(session[:uid])
    @data_x = @patient.data_xes.order(:percent).distinct.pluck(:percent)
    @data_y = @patient.grouped_by_gene[params[:gene]]

    coords = Equations.calculate_points(@data_x, @data_y)
    @mnk = "MNK::#{allowed_chart_params[:chart].camelize}".safe_constantize
    object = @mnk.new(data_x: @data_x, data_y: @data_y)
    approx_coordinates = object.process

    @coordinates = [{ name: @mnk.to_s.demodulize, data: coords }, { name: "#{@mnk.to_s.demodulize} approx coordinates", data: approx_coordinates.approx_y }]
    if params[:real_id].present?
      real_y = RealDataY.find(params[:real_id]).percent
      d = object.search_points(object.coefficients, real_y)
      @coordinates.push({ name: d, data: { d => real_y } })
    elsif params[:all].present?
      real_x = {}
      @patient.grouped_by_gene_real_y_without_id_long.values.each_with_index do |data, index|
        # next if index == 0
        # break if index == 2
        data.shift
        real_x[index] = {}
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

    render :search, layout: false
  end

  private

  def allowed_chart_params
    allowed_chart = %w(cubic_parabola cubic_parabola_with_extremes hyperbola)
    params.permit(:uid, :gene, :chart, :real_id, :all)
    params.delete(:chart) unless params[:chart].in? allowed_chart
    params
  end

  def init_data
    @patient = Patient.find_by_uid(session[:uid])
    @data_x = @patient.data_xes.order(:percent).distinct.pluck(:percent)
    data_y = @patient.grouped_by_gene
    @data_y = action_name == 'all' ? data_y.values : data_y[params[:gene]]
  end

  def real_y_params
    params.require(:information).permit(:real_y, :excel, :uid, :remotipart_submitted, :authenticity_token, :'X-Requested-With', :'X-Http-Accept')
  end
end
