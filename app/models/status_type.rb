class StatusType < ActiveRecord::Base
  self.table_name = 'pg_enum'
  activity_type_enum = PgEnum.for :status_type
  default_scope { where(enumtypid: activity_type_enum.typelem) }
  def name
    enumlabel
  end
end
