# not used for anything, but I'd started thinking about it, so might as well leave it in here
{quiz: {
  version:     1,
  title:       '??',
  description: '??',
  metadata:    {},
  children:    [
  ]
}}

require 'redcarpet'
require 'pygments'
# from readme https://github.com/vmg/redcarpet
class HTMLwithPygments < Redcarpet::Render::HTML
  def block_code(code, language)
    Pygments.highlight(code, lexer: language)
  end
end

def to_html(markdown)
  Redcarpet::Markdown.new(HTMLwithPygments,
                           space_after_headers: true,
                           fenced_code_blocks:  true,
                           autolink:            true,
                      ).render(markdown)
end

questions =
[{version: 1,
  question: "How do you find out whether an object has a method?",
  metadata: {},
  options: {
    a: "`object.kind_of?(:method_name)`",
    b: "`object.respond_to?(:method_name)`",
    c: "`object.is_a?(:method_name)`",
    d: "`object.include?(:method_name)`"
  },
  answer: :b,
  hint: 'If it has a method, then we would say it "responds to" that method.',
  further_thought: 'If we consider a method invocation to be a "message" that we are sending to the object,
    then we might say it responds to that message, hence the `respond_to?` method.
    This comes from a more theoretical perspective on "Object Oriented" programming.
    If you are trying to discover what you can do with the object, you could just call the method and see if it blows up or gives back a value.
    If the documentation is good, you can try reading that.
    You could load it up in pry and use `ls -v object` to see a list of methods.',
},
{ version: 1,
  question: "How do you find the list of all methods an object has?",
  metadata: {},
  options: {
    a: "`object.methods`",
    b: "`object.methods(false)`",
    c: "`object.respond_to?(:method_name)`",
    d: "`object.instance_methods`"
  },
  answer: :a,
  hint: '"All methods" implies an array, which ones imply an array? What might be the difference between `methods` and `instance_methods`? In method lists, `false` typically means "don\'t show me inherited values."',
  further_thought: 'Because we are calling methods on the object itself, we are interested in its `methods`,
    If we called `instance_methods`, that implies we are interested in methods that instances of this thing can call, which implies we are talking about a class.
    Verify this by comparing a class\'s instance methods to one fo its instance\'s methods. e.g. `String.instance_methods` and `"a".methods`.'
},
{ version:  1,
  question: 'Which code example is better encapsulated?',
  metadata: {},
  options: {
    a: '```ruby
class Medusa
  def stare_at(person)
    person.stoned = true
  end
end

class Person
  attr_accessor :stoned
end
```',
    b: '```ruby
class Medusa
  def stare_at(person)
    person.stone
  end
end

class Person
  def stoned?
    @stoned
  end

  def stone
    @stoned = true
  end
end
```'
  },
  answer: :b,
  hint: 'Encapsulation is about exposing the idea of what should be done without exposing the details of how it should be done.',
  further_thought: 'Encapsulation is about exposing the idea of what should be done without exposing the details of how it should be done.
    In the first example, Medusa can do what she wants to: turn the person to stone, but she also knows *how* to do it: she sets its `stoned` variable to true.
    In the second example, she is able to do it, but *does not* know how to. She just `stone`s the person, but leaves the details of what that means
    up to the `stone` method.

    Why does this matter? It matters because now, if we want to change the meaning of being stoned, we can do this without hunting down all the places
    around our codebase that depend on the details of how stonedness works.

    I know what you\'re thinking: "blah blah blah", when am I ever going to use this?

    Requirements change, dear student. Always and inevitably. Here are a few examples that could reasonably come up:

    For example: Say the person looks back at Sodom and Gomorrah and gets turned to salt. Or they have too much fun on Pleasure Island and get turned
    into a donkey. How would we represent this? Instead of a bunch of booleans (variables that can be true/false values), we\'d
    probably have a `@state` variable, which can be set to `:human`, `:stone`, `:salt`, or `:donkey`.
    Then the `stone` method is defined as `@state = :stone`, and the `stoned?` method is `@state == :stone`...
    The true/false representaiton is no more. But from the outside, calling `stone` will still result in the same behaviour of
    the `stoned?` method returning `true` afterwards. So with the latter code, it is just fine, but the former code needs to be modified.

    Another example: Say the person can have an "Amulet of Protection", which allows them to deflect petrification. Then when Medusa stares at them,
    they should not become stoned. If we put this in the person, then they can update the body to be `@stoned = true unless @items.any? { |item| item.prevents_petrification? }`
    The alternative would be to keep it in Medusa: `person.stoned = true unless person.items.any? { |item| item.prevents_petrification? }`.
    Notice at this point that Medusa knows a *whole lot* about the internal state of a person. She knows they have items, and what those items
    look like, and how to access them and so forth. All the details of the person are polluting the Medusa, and now we can\'t change any of them
    without coming here and changing Medusa, as well.

    So by telling the person it\'s been stoned, we can leave all the implementation details of what that means for the person up to it,
    protecting all the rest of our code from becoming coupled to its internal state. But by reaching into the person and setting state on them,
    we suddenly cannot change the person without also having to change Medusa.

    In this small example, the cost is low, but keep in mind that at some point you\'ll be working on a system that\'s been around for
    four years with 20 other developers, and enough code that you haven\'t read most of it. You\'ll need to change some class that\'s just
    like our Person, and some other class that\'s just like our Medusa either will or won\'t be coupled to it, but the system will be big enough
    that you  won\'t even know that class exists... until you break everything and then have to go hunt down all the classes that knew about
    the internal representation you changed ...Hopefully your tests are good enough to find this, otherwise you might not even know until it gets
    pushed to production and your site goes down.'
}
]

html_questions = questions.map { |question|
  q               = question.fetch :question # 'what is...'
  options         = question.fetch :options  # {a: 'abc', b: 'def'}
  answer          = question.fetch :answer   # :a
  hint            = question.fetch :hint     # 'think about such and such'
  further_thought = question.fetch :further_thought # 'lots of further thought, with newlines and such'
  further_thought.gsub! /^\s*/, ''
  hint.gsub!            /^\s*/, ''

  html = ""
  html << %'<div class="question">\n'
    html << "<h3>#{q}</h3>\n"
    html << "\n"

    html << "<div class='body'>\n"
      html << "<div class='options'>\n"
        options.each { |marker, text| html << "<div class='option'><div class='name'>#{marker}</div>\n<div class='value'>\n#{to_html text}\n</div></div>\n" }
      html << "</div>\n"

      html << %'<div class="answer">\n<b>#{answer}</b>\n</div>\n'
      html << "\n"

      html << %'<div class="hint">\n#{to_html hint}\n</div>\n'
      html << "\n"

      html << %'<div class="further-thought">\n#{to_html further_thought}\n</div>\n'
    html << "</div>\n"
  html << "</div>\n"
  html
}

html_intro = %'<div class="intro">\n#{to_html(<<MARKDOWN)}</div>'
# Quiz!

## Explanation

Go through the questions below. The purpose is not to test you, it's to allow you to test yourself.
Your goal isn't to get the answers right, it's to assimilate the knowledge in the questions. That's
why we made them, to give you another opportunity to address and think about things that we've seen
can be unclear for some students.

This is self-scored, it is for you to help push yourself along and address gaps in your knowledge.
It doesn't matter how many you get correct, it matters that you come to learn this information.

## How to take the quiz
* Look at the question, answer it in your head.
* If you need help, click the "hint" option.
* If you don't know the answer, go ahead and look at it, and then read through the further thought to help you understand
  why that is the answer. Come back in a day or two and try to go through the questions again. Your goal
  is to come to understand the answers and the reasoning behind them.
* If you do know the answer, say it to yourself in your head, then look and see that you were correct.
  Go ahead and read the "further thought" to see some of the context and nuance behind the answers that we were
  thinking about as we wrote them.
MARKDOWN

html = <<HTML
<!doctype html>
<html itemscope="" itemtype="http://schema.org/WebPage" lang="en">
  <head>
    <title>Google</title>
    <style type="text/css">
      .container {
        padding:  3em;
        position: relative;
      }
      .intro {
      }
      .question {
        position:         relative;
        background-color: #eee;
        margin:           0em;
        padding:          0em;
        margin-bottom:    2em;
      }
      .question h3 {
        box-sizing:       border-box;
        position:         relative;
        padding:          0.5em;
        margin:           0em;
        width:            100%;
        background-color: #858;
        font-size:        1.5em;
        font-family:      sans-serif;
        color:            #fff;
      }
      .question .body { /* omg, how dumb that I can't just use a body tag */
        padding:    1em;
        border:     5px solid #858;
        border-top: 0px;
      }
      .question .options .option {
        margin-bottom:  0.5em;
      }
      .question .options .name {
        display:        inline-block;
        vertical-align: top;
        font-weight:    bold;
        margin-right:   0.5em;
      }
      .question .options .value {
        display:        inline-block;
        vertical-align: top;
      }
      .question .options p {
        border: 0em;
        margin: 0em;
      }
      .question .answer {
        padding:          0.5em;
        margin-bottom:    0.5em;
        background-color: #afa;
        font-family:      sans-serif;
        font-weight:      bold;
        color:            #383;
      }
      .question .hint {
        padding:          0.5em;
        margin-bottom:    0.5em;
        background-color: #fc8;
        font-family:      sans-serif;
        font-weight:      bold;
        color:            #a50;
      }
      .question .further-thought {
        padding:          0.5em;
        background-color: #aaf;
        font-family:      sans-serif;
        font-weight:      bold;
        color:            #338;
      }
    </style>
    <script src="//ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js"></script>
  </head>
  <body>
    <div class="container">
      #{to_html html_intro}
      #{html_questions.join("\n")}
    </div>

    <script>
      var Hidable = function(placeholderText, domElement) {
        this.placeholderText = placeholderText
        this.actualText      = domElement.text()
        this.domElement      = domElement
        this.hidden          = false
      }
      Hidable.prototype.toggle = function() {
        if(this.hidden) this.show()
        else            this.hide()
        return this
      }
      Hidable.prototype.hide = function() {
        this.domElement.text(this.placeholderText)
        this.hidden = true
        return this
      }
      Hidable.prototype.show = function() {
        this.domElement.text(this.actualText)
        this.hidden = false
        return this
      }

      jQuery(function() {
        var hideByClass = function(className, placeholderText) {
          jQuery(className).each(function(index, rawDomElement) {
            var domElement = jQuery(rawDomElement)
            var hidable    = new Hidable(placeholderText, domElement).toggle()
            domElement.click(function() { hidable.toggle() })
          })
        }
        hideByClass('.answer',          'See Answer')
        hideByClass('.hint',            'Hint')
        hideByClass('.further-thought', 'Going Deeper')
      })
    </script>
  </body>
</html>
HTML
run lambda { |env|
  [200, {'Content-Type' => 'text/html'}, [html]]
}


# class Wizard
# end
#
# wizard = Wizard.new 'Sarah', false
#
# What's wrong with this code? (local var examples)
#
# Class#instance_method
# Class.method
#
# What exception will be raised?
# What does this exception mean?
# What information is relevant in this exception?
#
# -----
#
# For later:
#
# { version: 1,
#   question: "How do you find the list of an object's instance variables?",
#   metadata: {},
#   options: [
#     "`object.instance_variables`"
#   ],
#   hint: '',
#   further_thought: ''
# },
