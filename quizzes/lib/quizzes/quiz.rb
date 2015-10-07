require 'quizzes/question'

module Quizzes
  class Quiz
    ATTRIBUTES = [:id, :name, :description, :questions]

    def initialize(attributes={})
      self.attributes = attributes
    end

    ATTRIBUTES.each do |attribute_name|
      # getter
      define_method(attribute_name) {
        attributes[attribute_name]
      }

      # setter
      define_method("#{attribute_name}=") { |value|
        attributes[attribute_name] = value
      }
    end

    attr_reader :attributes
    def attributes=(attributes)
      @attributes ||= {}
      @attributes[:id]              = attributes[:id]          || attributes['id']          || nil
      @attributes[:name]            = attributes[:name]        || attributes['name']        || ''
      @attributes[:description]     = attributes[:description] || attributes['description'] || ''
      @attributes[:questions]       = attributes[:id]          || attributes['id']          || []
      @attributes[:questions] = normalize_questions @attributes[:questions]
    end

    def ==(other)
      attributes == other.attributes
    end

    private

    def normalize_questions(questions)
      @attributes[:questions]
    end
  end
end
