class ActivityToInstructor < ActiveRecord::Base
  self.table_name = 'activities_to_instructors'

  belongs_to :instructor
  belongs_to :activity
end
