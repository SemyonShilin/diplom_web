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
    #@data[:hash][@data[:header].last.first], @data[:hash][params[:gene]]
    name_gene = @data[:hash][@data[:header].last.first]
    gene_data = @data[:hash][params[:gene]]
    coefficients_cub_p = MNK::CubicParabola.calculate_coefficients(name_gene, gene_data)

    coords = Equations.calculate_points(name_gene, gene_data)

    approx_coordinates_cub_p = Equations::CubicParabola.calculate_approximation_points(name_gene, coefficients_cub_p)

    @coordinates_cub_p = [{name: 'cub_p', data: coords}, {name: 'cub_p approx coordinates', data: approx_coordinates_cub_p}]

    coefficients_hyp = MNK::Hyperbola.calculate_coefficients(name_gene, gene_data)

    approx_coordinates_hyp = Equations::Hyperbola.calculate_approximation_points(name_gene, coefficients_hyp)

    @coordinates_hyp = [{name: 'hyp', data: coords}, {name: 'hyp approx coordinates', data: approx_coordinates_hyp}]

    coefficients_cub_p_e = MNK::CubicParabolaWithExtremes.calculate_coefficients(name_gene, gene_data)

    approx_coordinates_cub_p_e = Equations::CubicParabola.calculate_approximation_points(name_gene, coefficients_cub_p_e)

    @coordinates_cub_p_e = [{name: 'cub_p_e', data: coords}, {name: 'cub_p_e approx coordinates', data: approx_coordinates_cub_p_e}]

    @shared = [{name: 'hyp', data: approx_coordinates_hyp},
               {name: 'cub_p', data: approx_coordinates_cub_p},
               {name: 'cub_p_e', data: approx_coordinates_cub_p_e}]

    mistake_p_e = Supports::Mistake.sum_approximation(gene_data, approx_coordinates_cub_p_e.values)
    mistake_cub = Supports::Mistake.sum_approximation(gene_data, approx_coordinates_cub_p.values)
    mistake_hyp = Supports::Mistake.sum_approximation(gene_data, approx_coordinates_hyp.values)

    @mist = {'cub_p_e' => mistake_p_e, 'cub_p' => mistake_cub, 'hyp' => mistake_hyp}
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
