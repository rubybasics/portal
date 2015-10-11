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
