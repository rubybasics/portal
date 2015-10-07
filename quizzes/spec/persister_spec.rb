require 'spec_helper'

RSpec.describe Quizzes::Persister do
  context 'questions' do
    it 'creates and loads a question' do
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
  end

  it 'saves and loads quizzes' do
    quiz1 = Quizzes::Quiz.new\
      name:        'q1',
      description: 'q1 description',
      questions:   [
        {question:        'q1.1',
         options:         {'q1.1 option1' => 'q1.1 value1'},
         answer:          'q1.1 option1',
         hint:            'q1.1 hint',
         further_thought: 'q1.1 further thought'
        },
        {question:        'q1.2',
         options:         {'q1.2 option1' => 'q1.2 value1'},
         answer:          'q1.2 option1',
         hint:            'q1.2 hint',
         further_thought: 'q1.2 further thought'
        },
      ]
    quiz2 = Quizzes::Quiz.new\
      name:        'q2',
      description: 'q2 description',
      questions:   [
        {question:        'q2.1',
         options:         {'q2.1 option1' => 'q2.1 value1'},
         answer:          'q2.1 option1',
         hint:            'q2.1 hint',
         further_thought: 'q2.1 further thought'
        },
        {question:        'q2.2',
         options:         {'q2.2 option1' => 'q2.2 value1'},
         answer:          'q2.2 option1',
         hint:            'q2.2 hint',
         further_thought: 'q2.2 further thought'
        },
      ]
    persister.create_quiz quiz1
    persister.create_quiz quiz2

    quiz1_loaded = persister.load_quiz quiz1.id
    quiz2_loaded = persister.load_quiz quiz2.id

    assert_equal quiz1, quiz1_loaded
    assert_equal quiz2, quiz2_loaded
  end

  it 'raises an error if told to create a quiz that already exists'
end
