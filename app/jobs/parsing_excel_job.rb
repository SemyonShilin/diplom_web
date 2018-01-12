class ParsingExcelJob < ApplicationJob
  queue_as :default

  def perform(*args)
    params = { path: args[0], uid: args[1] }
    params[:real_y] = args[2] if args[2]
    Information.new(params).create
  end
end
