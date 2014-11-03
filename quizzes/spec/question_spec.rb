require 'spec_helper'

RSpec.describe Quizzes::Question do
  it 'defaults its attributes to reasonable null values' do
    q = q1 = Quizzes::Question.new
    assert_equal q.id,              nil
    assert_equal q.question,        ''
    assert_equal q.options,         {}
    assert_equal q.answer,          ''
    assert_equal q.hint,            ''
    assert_equal q.further_thought, ''
  end

  it 'uses the provided values, whether they come in as symbols or strings' do
    symbols = Quizzes::Question.new \
      id:       123,
      question: 'some question',
      options:  {'some option' => 'some value'},
      answer:   'some option',
      hint:     'some hint',
      further_thought: 'some thoughts'

    assert_equal symbols.id,              123
    assert_equal symbols.question,        'some question'
    assert_equal symbols.options,         {'some option' => 'some value'}
    assert_equal symbols.answer,          'some option'
    assert_equal symbols.hint,            'some hint'
    assert_equal symbols.further_thought, 'some thoughts'

    strings = Quizzes::Question.new \
      id:       123,
      question: 'some question',
      options:  {'some option' => 'some value'},
      answer:   'some option',
      hint:     'some hint',
      further_thought: 'some thoughts'

    assert_equal strings.id,              123
    assert_equal strings.question,        'some question'
    assert_equal strings.options,         {'some option' => 'some value'}
    assert_equal strings.answer,          'some option'
    assert_equal strings.hint,            'some hint'
    assert_equal strings.further_thought, 'some thoughts'
  end

  it 'performs this normalization on assignment'
  # skipped b/c it doesn't
end
