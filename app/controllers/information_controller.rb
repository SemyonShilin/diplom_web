class InformationController < ApplicationController
  respond_to :html, :js, :json
  before_action :init_data, only: [:show, :draw]

  def show
    # @inf = Information.find(params[:id])
    # @data = ExcelDataParser.parse(@inf.excel)
    Gon.global.information_show_path = url_for([:build, @inf])
  end

  def new
    @information = Information.new
  end

  def create
    @information = Information.create(information_params)

    respond_with @information, status: :created, location: information_path(@information.id)
  end

  def draw
    data_x = @data[:hash][@data[:header].last.first]
    data_y = @data[:hash][params[:gene]]
    coords = Equations.calculate_points(data_x, data_y)

    parabola = MNK::CubicParabola.new(data_x: data_x, data_y: data_y)
    @coefficients_cub_p = parabola.calculate_coefficients
    approx_coordinates_cub_p = Equations::CubicParabola.calculate_approximation_points(data_x, @coefficients_cub_p)
    y = parabola.search_points(@coefficients_cub_p, 34)
    @coordinates_cub_p = [{name: 'cub_p', data: coords}, {name: 'cub_p approx coordinates', data: approx_coordinates_cub_p}, { name: 'point', data: { y => 34 } }]

    hyperbola = MNK::Hyperbola.new(data_x: data_x, data_y: data_y)
    @coefficients_hyp = hyperbola.calculate_coefficients
    approx_coordinates_hyp = Equations::Hyperbola.calculate_approximation_points(data_x, @coefficients_hyp)
    y = hyperbola.search_points(@coefficients_hyp, 34)
    @coordinates_hyp = [{name: 'hyp', data: coords}, {name: 'hyp approx coordinates', data: approx_coordinates_hyp}, { name: 'point', data: { y => 34 } }]

    parabola_with_e = MNK::CubicParabolaWithExtremes.new(data_x: data_x, data_y: data_y)
    @coefficients_cub_p_e = parabola_with_e.calculate_coefficients
    approx_coordinates_cub_p_e = Equations::CubicParabola.calculate_approximation_points(data_x, @coefficients_cub_p_e)
    y = parabola_with_e.search_points(@coefficients_cub_p_e, 34)
    @coordinates_cub_p_e = [{name: 'cub_p_e', data: coords}, {name: 'cub_p_e approx coordinates', data: approx_coordinates_cub_p_e}, { name: 'point', data: { y => 34 } }]

    mistake_p_e = Supports::Mistake.sum_approximation(data_y, approx_coordinates_cub_p_e.values)
    mistake_cub = Supports::Mistake.sum_approximation(data_y, approx_coordinates_cub_p.values)
    mistake_hyp = Supports::Mistake.sum_approximation(data_y, approx_coordinates_hyp.values)

    @mist = {'cub_p' => mistake_cub, 'hyp' => mistake_hyp, 'cub_p_e' => mistake_p_e}
  end

  private

  def information_params
    params.require(:information).permit(:excel, :gene)
  end

  def init_data
    @inf = Information.find(params[:id])
    @data = ExcelDataParser.parse(@inf.excel)
  end
end
