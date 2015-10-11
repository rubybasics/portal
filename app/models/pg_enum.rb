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

