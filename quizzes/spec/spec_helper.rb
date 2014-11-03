require 'quizzes'
require 'quizzes/persister'

module QuizTestHelpers
  def persister
    @persister ||= Quizzes::Persister.for(dbname: 'quizzes_test')
  end

  def assert_equal(expected, actual)
    expect(expected).to eq actual
  end
end

RSpec.configure do |c|
  c.include QuizTestHelpers
end
