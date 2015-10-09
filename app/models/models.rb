# jsl-portal-development=# select typelem from pg_type where typname = '_activity_type';
#  typelem
# ---------
#    30660
# (1 row)
class PgEnum < ActiveRecord::Base
  self.table_name  = 'pg_type'
  self.primary_key = 'typarray'
  def self.for(name)
    where(typname: "_#{name}").first
  end
end



# jsl-portal-development=# select * from pg_enum where enumtypid = 30660;
#  enumtypid | enumsortorder | enumlabel
# -----------+---------------+------------
#      30660 |             1 | daily_fact
#      30660 |             2 | warmup
#      30660 |             3 | lesson
#      30660 |             4 | work_time
#      30660 |             5 | homework
# (5 rows)
class ActivityType < ActiveRecord::Base
  self.table_name = 'pg_enum'
  activity_type_enum = PgEnum.for :activity_type
  default_scope { where(enumtypid: activity_type_enum.typelem) }
  def name
    enumlabel
  end
end

class StatusType < ActiveRecord::Base
  self.table_name = 'pg_enum'
  activity_type_enum = PgEnum.for :status_type
  default_scope { where(enumtypid: activity_type_enum.typelem) }
  def name
    enumlabel
  end
end

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
