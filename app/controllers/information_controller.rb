class InformationController < ApplicationController
  respond_to :html, :js, :json

  def show
    @inf = Information.find(params[:id])
    @data = ExcelDataParser.parse(@inf.excel)
    @parse_data = ExcelDataParser.worksheet_header(@data)
  end

  def new
    @information = Information.new
  end

  def create
    @information = Information.new(information_params)

    respond_with @information, status: :created, location: information_path(@information.id)
  end

  private

  def information_params
    params.require(:information).permit(:excel)
  end
end
