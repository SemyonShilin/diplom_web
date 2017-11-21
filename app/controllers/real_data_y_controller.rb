class RealDataYController < ApplicationController
  respond_to :html, :js, :json
  before_action :init_data, only: %i[show create]

  def show
    @information = Information.new({})

    coords = Equations.calculate_points(@data_x, @data_y)
    @mnk = "MNK::#{allowed_chart_params[:chart].camelize}".safe_constantize
    approx_coordinates = @mnk.new(data_x: @data_x, data_y: @data_y).process
    @coordinates = [{name: @mnk.to_s.demodulize, data: coords}, {name: "#{@mnk.to_s.demodulize} approx coordinates", data: approx_coordinates.approx_y}]#, { name: 'point', data: { y => 25 } }]
    approx_data_hash = { chart: approx_coordinates.approx_y.values }
    @mist = Supports::Mistake.calculate(@data_y, approx_data_hash)
  end

  def create
    @information = Information.new(real_y_params)

    coords = Equations.calculate_points(@data_x, @data_y)
    @mnk = "MNK::#{allowed_chart_params[:chart].camelize}".safe_constantize
    object = @mnk.new(data_x: @data_x, data_y: @data_y)
    approx_coordinates = object.process
    real_y = object.search_points(object.coefficients, @information.real_y)
    @coordinates = [{ name: @mnk.to_s.demodulize, data: coords }, { name: "#{@mnk.to_s.demodulize} approx coordinates", data: approx_coordinates.approx_y },
                    { name: 'point', data: { real_y => @information.real_y } }]

    render :create, layout: false
  end

  private

  def allowed_chart_params
    allowed_chart = %w(cubic_parabola cubic_parabola_with_extremes hyperbola)
    params.permit(:patient, :gene, :chart)
    params.delete(:chart) unless params[:chart].in? allowed_chart
    params
  end

  def init_data
    patient = Patient.find_by_name(params[:patient])
    @data_x = patient.data_xes.pluck(:percent)
    data_y = patient.grouped_by_gene
    @data_y = action_name == 'all' ? data_y.values : data_y[params[:gene]]
  end

  def real_y_params
    params.require(:information).permit(:real_y)
  end
end
