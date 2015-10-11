class ApiController < ActionController::Base
  def today
    date           = Date.parse(params[:date])
    activities     = Activity.where(date: date)
    activity_jsons = activities.map(&:as_json)

    json = {
      date:       date.to_s,
      cohorts:    Cohort.current.map(&:name),
      activities: activity_jsons,
    }

    render json: json
  end
end
