class CreateStructure < ActiveRecord::Migration
  def change
    require File.expand_path('../../playing-with-schema.rb', __dir__)
    define_schema(:pg)
    define_models
    define_data
    require "pry"
    binding.pry
    raise 'zomg!'
  end
end
