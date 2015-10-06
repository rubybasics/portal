class CreateStructure < ActiveRecord::Migration
  def change
    require File.expand_path('../../playing-with-schema.rb', __dir__)
    define_schema(:pg)
    define_models

    yesno "Define the data?" do
      define_data
    end

    yesno "Rollback?" do
      $stdout.puts
      $stdout.puts "\e[30;46m  ROLLING BACK!!  \e[0m"
      $stdout.puts
      $stderr.reopen '/dev/null' # for now, b/c we expect it to rollback
      raise 'zomg!'
    end
  end

  def yesno(question)
    $stdout.puts "------------------------------"
    $stdout.puts "#{question} (Y/n)"
    $stdout.puts "------------------------------"
    answer = $stdin.gets.to_s.chomp.downcase
    yield if 'y' == (answer[0] || 'y')
  end
end
