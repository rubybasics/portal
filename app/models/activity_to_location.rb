class ActivityToLocation < ActiveRecord::Base
  self.table_name = 'activities_to_locations'
  belongs_to :activity
  belongs_to :location
end
