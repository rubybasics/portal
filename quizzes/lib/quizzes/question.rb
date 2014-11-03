module Quizzes
  class Question
    ATTRIBUTES = [:id, :question, :options, :answer, :hint, :further_thought]

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
      @attributes[:id]              = attributes[:id]              || attributes['id']              || nil
      @attributes[:question]        = attributes[:question]        || attributes['question']        || ''
      @attributes[:options]         = attributes[:options]         || attributes['options']         || {}
      @attributes[:answer]          = attributes[:answer]          || attributes['answer']          || ''
      @attributes[:hint]            = attributes[:hint]            || attributes['hint']            || ''
      @attributes[:further_thought] = attributes[:further_thought] || attributes['further_thought'] || ''
    end

  end
end
