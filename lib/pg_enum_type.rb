# our current Rails (2.4.2) uses this
require 'active_record/type/value'
# However, on Rails HEAD they moved it to active_model/type/value
# and the constant is ActiveModel::Type::Value
# note that it's :nodoc:, but Sean used it in his Railsconf presentation

class PgEnumType < ActiveRecord::Type::Value
  def initialize(column_name:, **options)
    @human_column_name = column_name
    super(**options)
  end

  def type
    :pg_enum
  end

  def changed_in_place?(*)
    false
  end

  def serialize(name)
    name.to_s
  end

  def all(connection)
    connection.execute(<<-SQL).map { |row| cast_value row['enumlabel'] }
      SELECT enumlabel
        FROM pg_enum
        INNER JOIN pg_type
        ON pg_enum.enumtypid = pg_type.typelem
        WHERE pg_type.typname = #{connection.quote db_column_name};
    SQL
  end

  private

  attr_accessor :human_column_name

  def db_column_name
    "_#{human_column_name}"
  end

  def cast_value(value)
    value.to_sym
  end
end
