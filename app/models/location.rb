class Location < ActiveRecord::Base
  has_many :activities_to_locations, class_name: 'ActivityToLocation'
  has_many :activities, through: :activities_to_locations
end
