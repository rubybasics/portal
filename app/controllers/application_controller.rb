require_relative '../models/models'
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  Deject self, :user_repository

  before_action :require_login
  before_action :require_invitation_or_admin
  before_action :todays_date

  helper_method :current_user
  def current_user
    @current_user ||= user_repository.find session[:user_id]
  end

  helper_method :todays_date
  def todays_date
    @todays_date ||= Date.current
  end

  private

  def require_login
    current_user
  rescue Jsl::Identity::ResourceNotFound
    requested_url = Rack::Request.new(request.env).url
    redirect_to user_repository.login_url(requested_url)
  end

  def require_invitation_or_admin
    return if current_user.invited? || current_user.admin?
    render text:   'An invitation is required to visit this site',
           status: :forbidden
  end
end
