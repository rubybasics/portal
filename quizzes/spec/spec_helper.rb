require 'quizzes'
require 'quizzes/persister'

persister = Quizzes::Persister.for(dbname: 'quizzes_test')
RSpec.configure do |c|
  c.include Module.new {
    define_method(:persister) { persister }
  }
end
