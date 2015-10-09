class Admin::ActivitiesController < ApplicationController
  def new
    @activity = Activity.new
  end

  def create
    Activity.create(activity_params)
    redirect_to admin_today_path(params[:date])
  end

  private

  def activity_params
    hash = params.require(:activity).permit(:title,
                                            :start,
                                            :finish,
                                            :content,
                                            :activity_type,
                                            location_ids: [],
                                            instructor_ids: [],
                                            cohorts_ids: [])

    i_ids = params[:activity][:instructor_ids].keys
    l_ids = params[:activity][:location_ids].keys
    c_ids = params[:activity][:cohort_ids].keys

    hash[:instructor_ids] = i_ids
    hash[:location_ids]   = l_ids
    hash[:cohort_ids]     = c_ids
    hash[:date]           = params[:date]
    hash
  end
end
