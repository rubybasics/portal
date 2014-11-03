require 'spec_helper'

RSpec.describe Quizzes::Persister do
  def assert_equal(expected, actual)
    expect(expected).to eq actual
  end

  context 'questions' do
    it 'saves and loads a question' do
      q1 = Quizzes::Question.new \
        question: 'why?',
        options:  {'a' => 'answer1', 'b' => 'answer2', 'c' => 'answer3'},
        answer:   'b',
        hint:     'some hint',
        further_thought: 'some thoughts'
      assert_equal q1.id, nil
      persister.create_question q1
      expect(q1.id).to be_a_kind_of Fixnum

      q2 = persister.load_question q1.id
      assert_equal q2.question,        'why?'
      assert_equal q2.options,         {'a' => 'answer1', 'b' => 'answer2', 'c' => 'answer3'}
      assert_equal q2.answer,          'b'
      assert_equal q2.hint,            'some hint'
      assert_equal q2.further_thought, 'some thoughts'
    end

    # it 'knows whether a quiz is valid' do
    #   q1 = Quizzes::Question.new question: 'why?', options: {a: 'a', b: 'b', c: 'c'}, answer: :b, hint: 'some hint', further_thought: 'some thoughts'
    #   expect(q1).to eq q2
    # end
  end

  it 'saves and loads a quiz'
  it 'does not load a quiz\'s questions that don\'t belong to it'
end
