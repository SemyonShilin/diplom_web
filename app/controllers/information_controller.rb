class InformationController < ApplicationController
  respond_to :html, :js, :json

  def show
    @inf = Information.find(params[:id])
    @data = ExcelDataParser.parse(@inf.excel)
    Gon.global.information_show_path = url_for([:build, @inf])
  end

  def new
    @information = Information.new
  end

  def create
    @information = Information.create(information_params)

    respond_with @information, status: :created, location: information_path(@information.id)
  end

  private

  def information_params
    params.require(:information).permit(:excel)
  end
end
