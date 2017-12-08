class ParsingExcelJob < ApplicationJob
  queue_as :parsing

  def perform(obj)
    obj.create
  end
end
