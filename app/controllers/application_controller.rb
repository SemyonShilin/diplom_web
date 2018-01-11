class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :set_uid

  private

  def set_uid
    session[:uid] ||= SecureRandom.urlsafe_base64(nil, false)
  end
end
