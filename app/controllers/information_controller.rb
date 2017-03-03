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
    @coefficients = MNK::CubicParabola.calculate_coefficients(@data[:hash][@data[:header].last.first],
                                                       @data[:hash][params[:gene]])#@data[:hash][@data[:header].last.first], @data[:hash][params[:gene]]

    coords = Equations::CubicParabola.calculate_points(@data[:hash][@data[:header].last.first],
                                                       @data[:hash][params[:gene]])

    approx_coordinates = Equations::CubicParabola.calculate_approximation_points(@data[:hash][@data[:header].last.first],
                                                                          @coefficients)
    @coordinates = [coords, approx_coordinates]
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
