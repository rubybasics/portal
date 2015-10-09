class Admin::AdminController < ApplicationController
  before_action :require_admin

  def index

  end

  def require_admin
    redirect_to root_path unless current_user.admin?
  end
end
