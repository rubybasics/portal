class Instructor < ActiveRecord::Base
  has_many :activituies_to_instrcctors, class_name: 'ActivityToInstructor'
  has_many :activities, through: :activities_to_cohorts
end
