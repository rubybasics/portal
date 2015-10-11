require 'pg_enum_type'

class Cohort < ActiveRecord::Base
  has_many :activities_to_cohorts, class_name: 'ActivityToCohort'
  has_many :activities, through: :activities_to_cohorts

  class << self
    attr_accessor :status_types
  end
  status_type = PgEnumType.new(column_name: :status_type)
  self.status_types = status_type.all(connection)
  attribute :status_type, status_type

  status_types.each do |type|
    define_singleton_method(type) { where status: type }
  end
end
