class ParsingExcelJob < ApplicationJob
  queue_as :default

  def perform(path, uid)
    Information.new(path: path, uid: uid).create
  end
end
