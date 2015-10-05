class CreateStructure < ActiveRecord::Migration
  def change
    require File.expand_path('../../playing-with-schema.rb', __dir__)
    define_schema(:pg)
    define_models
    define_data
    $stdout.puts
    $stdout.puts "\e[30;46m  ROLLING BACK!!  \e[0m"
    $stdout.puts
    $stderr.reopen '/dev/null' # for now, b/c we expect it to rollback
    raise 'zomg!'
  end
end
