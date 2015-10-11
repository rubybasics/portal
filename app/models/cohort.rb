class Cohort < ActiveRecord::Base
  has_many :activities_to_cohorts, class_name: 'ActivityToCohort'
  has_many :activities, through: :activities_to_cohorts

  def self.current
    where status: :current
  end
end

