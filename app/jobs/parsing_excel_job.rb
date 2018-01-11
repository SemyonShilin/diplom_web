class ParsingExcelJob < ApplicationJob
  queue_as :parsing

  def perform(params)
    params.create
  end
end
