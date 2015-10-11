class ActivityToCohort < ActiveRecord::Base
  self.table_name = 'activities_to_cohorts'
  belongs_to :activity
  belongs_to :cohort
end
