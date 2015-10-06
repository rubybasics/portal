class Activity < ActiveRecord::Base
  has_many :activities_to_cohorts, class_name: 'ActivityToCohort'
  has_many :activities_to_instructors, class_name: 'ActivityToInstructor'
  has_many :cohorts, through: :activities_to_cohorts
  has_many :instructors, through: :activities_to_instructors
  has_one :location

  validates :activity_type, presence: true
  validates :date, presence: true
end

class ActivityToCohort < ActiveRecord::Base
  self.table_name = 'activities_to_cohorts'
  belongs_to :activity
  belongs_to :cohort
end

class ActivityToInstructor < ActiveRecord::Base
  self.table_name = 'activities_to_instructors'
  belongs_to :instructor
  belongs_to :activity
end

class Cohort < ActiveRecord::Base
  has_many :activities_to_cohorts, class_name: 'ActivityToCohort'
  has_many :activities, through: :activities_to_cohorts
  def self.current
    where status: :current
  end
end

class Instructor < ActiveRecord::Base
  has_many :activituies_to_instrcctors, class_name: 'ActivityToInstructor'
  has_many :activities, through: :activities_to_cohorts
end

class Location < ActiveRecord::Base
  belongs_to :activity
end
