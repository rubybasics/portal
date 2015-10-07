require 'spec_helper'

RSpec.describe Quizzes::Question do
  it 'defaults its attributes to reasonable null values' do
    quiz1 = Quizzes::Quiz.new
    assert_equal '', quiz1.name
    assert_equal '', quiz1.description
    assert_equal [], quiz1.questions
  end

  it 'can take quizzes or hashes of quiz attributes' do
    quiz = Quizzes::Quiz.new questions: [{question: 'q1'}, Quizzes::Question.new({question: 'q2'})]
    assert_equal 'q1', quiz.questions[0].question
    assert_equal 'q2', quiz.questions[1].question
  end

  it 'is equal to another quiz if all their attributes are equal' do
    quiz                = Quizzes::Quiz.new name: 'q1', description: 'q1 description', questions: [{question: 'q1'}, {question: 'q2'}]
    same                = Quizzes::Quiz.new quiz.attributes
    different_name      = Quizzes::Quiz.new quiz.attributes.merge(name:        'other name')
    different_desc      = Quizzes::Quiz.new quiz.attributes.merge(description: 'other desc')
    different_questions = Quizzes::Quiz.new quiz.attributes.merge(questions:   [{question: 'not q1'}])

    assert_equal quiz, same
    refute_equal quiz, different_name
    refute_equal quiz, different_desc
    refute_equal quiz, different_questions
  end
end
