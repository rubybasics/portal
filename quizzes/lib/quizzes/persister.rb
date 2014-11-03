require 'quizzes/question'
require 'pg'
require 'pg_hstore'

module Quizzes
  class Persister
    def self.for(connection_attributes)
      new PG.connect(connection_attributes)
    end

    def initialize(connection)
      @connection = connection
    end

    def create_question(question)
      @connection.exec "BEGIN;"
      @connection.exec_params 'INSERT INTO quiz_questions (question, options, answer, hint, further_thought) '\
                                                  'VALUES ($1,'      '$2,'    '$3,'   '$4,' '$5);',
                              [question.question,
                               PgHstore.dump(question.options, true),
                               question.answer,
                               question.hint,
                               question.further_thought
                              ]
      result = @connection.exec("SELECT currval('quiz_questions_id_seq'::regclass);")
      @connection.exec('COMMIT;')
      question.id = result.getvalue(0, 0).to_i
      question
    end

    def load_question(id)
      result     = @connection.exec_params('SELECT * FROM quiz_questions WHERE id = $1 LIMIT 1', [id])
      attributes = result.to_a.first
      attributes['options'] = PgHstore.load(attributes['options']||'')
      Question.new attributes
    end
  end
end
