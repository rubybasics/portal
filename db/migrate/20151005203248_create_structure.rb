class CreateStructure < ActiveRecord::Migration
  def change
    connection.execute "CREATE TYPE activity_type AS ENUM ('daily_fact', 'warmup', 'lesson', 'work_time', 'homework');"

    create_table :activities do |t|
      t.column :activity_type, :activity_type
      t.text   :title
      t.text   :content
      t.datetime :start
      t.datetime :finish
      t.text :groups
    end

    create_table :activities_to_cohorts do |t|
      t.integer :activity_id
      t.integer :cohort_id
    end

    create_table :activities_to_instructors do |t|
      t.integer :activity_id
      t.integer :instructor_id
    end

    connection.execute "CREATE TYPE status_type AS ENUM ('pending', 'current', 'graduated');"

    create_table :cohorts do |t|
      t.string :name
      t.column :status, :status_type
    end

    create_table :instructors do |t|
      t.string :name
    end

    create_table :locations do |t|
      t.string :name
      t.integer :activity_id
    end
  end
end
