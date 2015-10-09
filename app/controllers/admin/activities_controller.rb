class Admin::ActivitiesController < ApplicationController
  def new
    @activity = Activity.new
  end
end
