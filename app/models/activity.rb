require 'pg_enum_type'

class Activity < ActiveRecord::Base
  has_many :activities_to_cohorts, class_name: 'ActivityToCohort'
  has_many :activities_to_instructors, class_name: 'ActivityToInstructor'

  has_many :activities_to_locations, class_name: 'ActivityToLocation'
  has_many :locations, through: :activities_to_locations

  has_many :cohorts, through: :activities_to_cohorts
  has_many :instructors, through: :activities_to_instructors

  validates :activity_type, presence: true
  validates :date, presence: true

  class << self
    attr_accessor :activity_types
  end
  activity_type = PgEnumType.new column_name: :activity_type
  self.activity_types = activity_type.all(connection)
  attribute :activity_type, activity_type
end
