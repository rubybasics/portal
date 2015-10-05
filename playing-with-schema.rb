def define_schema(db_type)
  atype = :string
  if db_type == :pg
    atype = :activity_type
    connection.execute "CREATE TYPE activity_type AS ENUM ('daily_fact', 'warmup', 'lesson', 'work_time', 'homework');"
  end

  create_table :activities do |t|
    t.column :activity_type, atype
    t.text   :title
    t.text   :content
    t.datetime :start
    t.datetime :finish
    t.text :groups
  end

  create_table :activities_to_cohorts do |t|
    t.integer :activity_id
    t.integer :cohort_id
  end

  create_table :activities_to_instructors do |t|
    t.integer :activity_id
    t.integer :instructor_id
  end

  status_type = :string
  if db_type == :pg
    status_type = :status_type
    connection.execute "CREATE TYPE status_type AS ENUM ('pending', 'current', 'graduated');"
  end

  create_table :cohorts do |t|
    t.string :name
    t.column :status, status_type
  end

  create_table :instructors do |t|
    t.string :name
  end

  create_table :locations do |t|
    t.string :name
    t.integer :activity_id
  end
end

::Object.send :define_method, :define_models do
  class Activity < ActiveRecord::Base
    has_many :activities_to_cohorts, class_name: 'ActivityToCohort'
    has_many :activities_to_instructors, class_name: 'ActivityToInstructor'
    has_many :cohorts, through: :activities_to_cohorts
    has_many :instructors, through: :activities_to_instructors
    has_one :location
  end

  class ActivityToCohort < ActiveRecord::Base
    self.table_name = 'activities_to_cohorts'
    belongs_to :activity
    belongs_to :cohort
  end

  class ActivityToInstructor < ActiveRecord::Base
    self.table_name = 'activities_to_instructors'
    belongs_to :instructor
    belongs_to :activity
  end

  class Cohort < ActiveRecord::Base
    has_many :activities_to_cohorts, class_name: 'ActivityToCohort'
    has_many :activities, through: :activities_to_cohorts
    def self.current
      where status: :current
    end
  end

  class Instructor < ActiveRecord::Base
    has_many :activituies_to_instrcctors, class_name: 'ActivityToInstructor'
    has_many :activities, through: :activities_to_cohorts
  end

  class Location < ActiveRecord::Base
    belongs_to :activity
  end
end

def define_data
  require 'rspec/core'
  integration_tests = RSpec.describe 'Integration test' do
    it 'can represent all the data from 2015-08-26, and generate content for today.turing.io' do
      c1510 = Cohort.create! name: '1510', status: :pending
      c1508 = Cohort.create! name: '1508', status: :current
      c1507 = Cohort.create! name: '1507', status: :current
      c1505 = Cohort.create! name: '1505', status: :current
      c1503 = Cohort.create! name: '1503', status: :current
      c1502 = Cohort.create! name: '1502', status: :graduated

      cjorge  = Instructor.create! name: 'Jorge Tellez'
      chorace = Instructor.create! name: 'Horace Williams'
      ccheek  = Instructor.create! name: 'Josh Cheek'
      cmejia  = Instructor.create! name: 'Josh Mejia'
      cjeff   = Instructor.create! name: 'Jeff Casimir'

      bwspace = Location.create! name: "Big workspace"
      classroom_b = Location.create! name: "Classroom B"
      classroom_a = Location.create! name: "Classroom A"

      date = Time.parse '2015-08-26'

      Object.send :define_method, :at do |hours, minutes=0|
        date + hours.hours + minutes.minutes
      end

      a = Activity.create! do |a|
        a.activity_type = :daily_fact
        a.content       = 'Today, in 1952, Will Shortz was born.'
        a.start         = date
        a.finish        = date + 1.day
      end

      a = Activity.create! do |a|
        a.activity_type = :warmup
        a.cohorts       = Cohort.current
        a.start         = at 8, 30
        a.finish        = at 9
        a.content       = <<-MARKDOWN.gsub(/^ */, '')
          Scientists have developed an allergy test that produces a single numeric score that summarizes information about all the allergies a person has.

          The test checks for the following allergies and assigns them the corresponding value:

          * eggs (1)
          * peanuts (2)
          * shellfish (4)
          * strawberries (8)
          * tomatoes (16)
          * chocolate (32)
          * pollen (64)
          * cats(128)

          If Jorge is allergic to peanuts and chocolate, he gets a score of 34.

          Your job is to write a program that takes the number and translates it back the allergens that the patient is allergic to.

          In this case, 34 would translate back into a report saying that Jorge was allergic to peanuts and chocolate.

          Because you all love TDD, here are some cases that you can test against:

          A score of two would mean that the patient is allergic to just peanuts.

          A score of 3 would mean that the patient is allergic to eggs and peanuts.
        MARKDOWN
      end

      a = Activity.create! do |a|
        a.activity_type = :lesson
        a.start         = at 9
        a.finish        = at 9, 30
        a.instructors   = [Instructor.first]
        a.cohorts       = [Cohort.find_by(name: "1503")]
        a.title         = "Exercise -- SuperFizz in JS"
        a.content       = <<-MARKDOWN.gsub(/^ */, '')
          Start the day off right by joining Horace in classroom C to write
          a variant of FizzBuzz, [SuperFizz](https://github.com/turingschool/challenges/blob/master/super_fizz.markdown).
        MARKDOWN
      end

      a = Activity.create! do |a|
        a.activity_type = :lesson
        a.start         = at 9
        a.finish        = at 9, 30
        a.instructors   = [chorace]
        a.cohorts       = [c1503]
        a.title         = "Exercise -- SuperFizz in JS"
        a.content       = <<-MARKDOWN.gsub(/^ */, '')
          Start the day off right by joining Horace in classroom C to write
          a variant of FizzBuzz, [SuperFizz](https://github.com/turingschool/challenges/blob/master/super_fizz.markdown).
        MARKDOWN
      end

      a = Activity.create! do |a|
        a.activity_type = :lesson
        a.start         = at 9, 30
        a.finish        = at 12
        a.instructors   = [chorace]
        a.cohorts       = [c1503]
        a.title         = "Full-Stack Integration Testing with Selenium"
        a.content      = <<-MARKDOWN.gsub(/^ */, '')
          Join Horace in Classroom C to practice working with Selenium,
          a browser driver for Capybara which let's us write integration
          tests which actually exercise our JS code as well!

          [Lesson](https://github.com/turingschool/lesson_plans/blob/master/ruby_04-apis_and_scalability/full_stack_integration_testing_with_selenium.markdown)
        MARKDOWN
        a.groups        = <<-MARKDOWN.gsub(/^ */, '')
          * Margarett Ly & Drew Reynolds
          * Max Tedford & Vanessa Gomez
          * Whitney Hiemstra & Sally MacNicholas
          * Morgan Miller & Justin Holmes
          * Brett Grigsby & Josh Cass
        MARKDOWN
      end

      a = Activity.create! do |a|
        a.activity_type = :work_time
        a.start         = at 1
        a.finish        = at 4
        a.cohorts       = [c1503]
        a.title         = 'Project Work Time and Check-Ins'
        a.groups        = <<-MARKDOWN.gsub(/^ */, '')
          ## With     Horace

          * 1:00 - Brett Grigsby
          * 1:30 - Drew Reynolds
          * 2:00 - Vanessa Gomez
          * 2:30 - Margarett Ly

          ### With Brittany

          * 1:00 - Morgan Miller
          * 1:30 - Justin Holmes
          * 2:00 - Josh Cass
          * 2:30 - Whitney Hiemstra

          ### With Andrew

          * 1:00 - Max Tedford
          * 1:30 - Sally MacNicholas
          * 2:00 - Lev Kravinsky
        MARKDOWN
      end

      a = Activity.create! do |a|
        a.activity_type = :work_time
        a.start         = 1
        a.finish        = 4
        a.cohorts       = [c1505]
        a.instructors   = [cjorge]
        a.location      = bwspace
        a.title         = 'Project Work Time'
        a.content       = <<-MARKDOWN.gsub(/^ */, '')
        Work on your Pivot projects with your teams. Remember to focus on your user stories. Iteration 1 is due on Thursday afternoon.
        Andrew will be available for questions.
        MARKDOWN
      end

      a = Activity.create! do |a|
        a.activity_type = :lesson
        a.start         = at 9
        a.finish        = at 9, 30
        a.cohorts       = [c1507]
        a.instructors   = [cmejia]
        a.location      = classroom_b
        a.title         = 'CRUD Homework Review'
      end

      a = Activity.create! do |a|
        a.activity_type = :lesson
        a.start         = at 9, 30
        a.finish        = at 12
        a.cohorts       = [c1507]
        a.instructors   = [cmejia]
        a.location      = classroom_b
        a.title         = 'Model Testing in Sinatra'
        a.content       = <<-MARKDOWN.gsub(/^ */, '')
        [Lesson Plan](https://github.com/turingschool/lesson_plans/blob/master/ruby_02-web_applications_with_ruby/model_testing_in_sinatra.markdown)
        MARKDOWN
      end

      a = Activity.create! do |a|
        a.activity_type = :lesson
        a.start         = at 1
        a.finish        = at 1, 30
        a.cohorts       = [c1507]
        a.instructors   = [cmejia]
        a.location      = classroom_b
        a.title         = 'Nokogiri'
        a.content       = <<-MARKDOWN.gsub(/^ */, '')
        Enjoy this [challenge](https://github.com/turingschool/challenges/blob/master/parsing_html.markdown).
        MARKDOWN
      end

      a = Activity.create! do |a|
        a.activity_type = :lesson
        a.start         = at 1, 30
        a.finish        = at 4
        a.cohorts       = [c1507]
        a.instructors   = [cmejia]
        a.location      = classroom_b
        a.title         = 'Acceptance Testing with Capybara'
        a.content       = <<-MARKDOWN.gsub(/^ */, '')
        [Lesson Plan](https://github.com/turingschool/lesson_plans/blob/master/ruby_02-web_applications_with_ruby/feature_testing_in_sinatra_with_capybara.markdown)
        MARKDOWN
      end

      # need to add distinction between Echo and Foxtrot somehow
      a = Activity.create! do |a|
        a.activity_type = :lesson
        a.start         = at 9
        a.finish        = at 10, 30
        a.cohorts       = [c1508]
        a.instructors   = [cjeff]
        a.location      = classroom_a
        a.title         = 'Introducing Arrays'
        a.content       = <<-MARKDOWN.gsub(/^ */, '')
        Classroom A with Jeff to [learn about arrays and hashes](https://github.com/turingschool/lesson_plans/blob/master/ruby_01-object_oriented_programming_with_ruby/arrays_and_hashes.markdown).
        MARKDOWN
      end

      a = Activity.create! do |a|
        a.activity_type = :lesson
        a.start         = at 10, 30
        a.finish        = at 12
        a.cohorts       = [c1508]
        a.instructors   = [cjeff]
        a.location      = classroom_a
        a.title         = 'Introducing Hashes'
        a.content       = <<-MARKDOWN.gsub(/^ */, '')
        Classroom A with Jeff to [learn about arrays and hashes](https://github.com/turingschool/lesson_plans/blob/master/ruby_01-object_oriented_programming_with_ruby/arrays_and_hashes.markdown).
        MARKDOWN
      end

      a = Activity.create! do |a|
        a.activity_type = :lesson
        a.start         = at 1
        a.finish        = at 2, 30
        a.cohorts       = [c1508]
        a.instructors   = [ccheek]
        a.location      = classroom_a
        a.title         = 'How Testing Works'
        a.content       = <<-MARKDOWN.gsub(/^ */, '')
        We'll be working in this repository: [https://github.com/JoshCheek/how-to-test](https://github.com/JoshCheek/how-to-test).

        Make sure you know how to run programs in the shell, and have the keybindings
        [https://github.com/JoshCheek/1508/blob/3de9c9729481c59bcebc6f30b4f10ea52ed5d36c/shell.md#keybindings](https://github.com/JoshCheek/1508/blob/3de9c9729481c59bcebc6f30b4f10ea52ed5d36c/shell.md#keybindings).
        I'm going to make you show the person adjacent to you before we go onto this stuff
        (the last time I gave this lesson, it took 8 minutes to edit a file, I don't want to lose that kind of time anymore).
        If you're not confident you can do those things, take 10 min during your lunch and refresh yourself.
        MARKDOWN
      end

      a = Activity.create! do |a|
        a.activity_type = :lesson
        a.start         = at 2, 30
        a.finish        = at 3
        a.cohorts       = [c1508]
        a.instructors   = [ccheek]
        a.location      = classroom_a
        a.title         = 'Sorting Suite Kickoff'
        a.content       = <<-MARKDOWN.gsub(/^ */, '')
        Stay at the front of Classroom A for sorting algorithms, y'all [https://vimeo.com/channels/sortalgorithms](https://vimeo.com/channels/sortalgorithms).

        First project, [Sorting Suite](https://github.com/turingschool/sorting-suite).

        This is a project with a grading matrix.
        It is due 9AM on Monday.
        You will work independently (ie you will each have your own, but you can confer with other students... confer != share code)
        For planning purposes, our guess is that this will take you in the range of 20 hrs.
        MARKDOWN
      end

      a = Activity.create! do |a|
        a.activity_type = :lesson
        a.start         = at 3
        a.finish        = at 4
        a.cohorts       = [c1508]
        a.instructors   = [ccheek]
        a.location      = classroom_a
        a.title         = 'TDD Tutorial'
        a.content       = <<-MARKDOWN.gsub(/^ */, '')
        Big Surprise, you are in the front of Classroom A.

        Work independently on [this Intro to TDD tutorial](http://tutorials.jumpstartlab.com/topics/testing/intro-to-tdd.html).
        We'll make a few changes, such as using [mrspec](https://rubygems.org/gems/mrspec)
        to run our tests, but other than that, follow along, as described.
        MARKDOWN
      end

      a = Activity.create! do |a|
        a.activity_type = :homework
        a.start         = at 4
        a.finish        = at 32
        a.cohorts       = [c1508]
        a.content        = <<-MARKDOWN.gsub(/^ */, '')
        On Monday, I told you that you need to get over yourselves.
        Write 1 sentence or more identifying an area that you would benefit from applying these ideas to:

        * **get over your fear**, so you don't spend years avoiding a skill you could have learned in a week.
          Have you ever just sat and enjoyed failure? Honest question.
          No amount of success has ever empowered me as much as realizing I could fail and be completely okay.
        * **get over your condescension** so you don't prevent people from feeling safe enough to try their hardest
          [Bonus quote from Jane Goodall!](http://www.infinitelooper.com/?v=vibssrQKm60#/581;611).
        * **get over your predispositions** so you don't flounder and possibly repeat or drop out.
          The most compelling things about programming were the new ways I learned to think.
          In fact, it's suspect to say that I even did think before programming.

        Make sure you've watched this 2 minute video to see what it looks like when I navigate in the shell.
        [https://s3.amazonaws.com/josh.cheek/screencasts/rachel/navigation.mp4](https://s3.amazonaws.com/josh.cheek/screencasts/rachel/navigation.mp4)

        Practice until you can do each of these katas in under 20 seconds:

        * [https://github.com/JoshCheek/1508/blob/3de9c9729481c59bcebc6f30b4f10ea52ed5d36c/shell.md#kata-2](https://github.com/JoshCheek/1508/blob/3de9c9729481c59bcebc6f30b4f10ea52ed5d36c/shell.md#kata-2)
        * [https://github.com/JoshCheek/1508/blob/3de9c9729481c59bcebc6f30b4f10ea52ed5d36c/shell.md#kata-3](https://github.com/JoshCheek/1508/blob/3de9c9729481c59bcebc6f30b4f10ea52ed5d36c/shell.md#kata-3)

        As soon as you sit down tomorrow, explain to each of the students adjacent to you what these directories mean: `/`, `~`, `.`, `..`,
        the entire description should be less than 2 sentences. If someone adjacent to you explains them to you,
        then listen attentively. If you believe they understand, give them a warm smile.
        If you are unsure, ask a question to verify, and if they allay your concerns, give them a warm smile.
        If they still seem confused, explain to them what these directories mean, have them repeat it back to you, ask another question to verify they understand,
        and give them a warm smile.
        MARKDOWN
      end

      a = Activity.create! do |a|
        a.activity_type = :lesson
        a.instructors   = [cjeff]
        a.cohorts       = [c1508]
        a.location      = classroom_a
        a.start         = at 1
        a.finish        = at 1, 30
        a.title         = 'SuperFizz Recap'
        a.content       = 'Join Jeff at the Mega Table.'
      end

      a = Activity.create! do |a|
        a.activity_type = :lesson
        a.instructors   = [cjeff]
        a.cohorts       = [c1508]
        a.location      = classroom_a
        a.start         = at 1, 30
        a.finish        = at 2
        a.title         = 'Mastermind kickoff'
        a.content       = "It's time to start your first project, [Mastermind](https://github.com/turingschool/curriculum/blob/master/source/projects/mastermind.markdown). Meet Jeff at the Mega Table to discuss and plan."
      end

      a = Activity.create! do |a|
        a.activity_type = :lesson
        a.instructors   = [cjeff]
        a.cohorts       = [c1508]
        a.location      = classroom_a
        a.start         = at 2
        a.finish        = at 4
        a.title         = 'Array and Hash Exercises'
        a.content       = <<-MARKDOWN.gsub(/^ */, '')
        Remember when we said we want you to have *two* things to do at all times? Join Mike at the Mega Table to start into a second. You'll learn how to do cool
        and interesting things with Arrays and Hashes.

        [Exercises Repository](https://github.com/turingschool/ruby-exercises/tree/master/core-types)
        MARKDOWN
      end

      expect(a.activity_type).to eq :lesson
      expect(a.start).to eq Time.parse('2015-08-26 02:00:00 -0600')
      expect(a.finish).to eq Time.parse('2015-08-26 04:00:00 -0600')
      expect(a.cohorts).to eq [c1508]
      expect(a.content).to eq "Remember when we said we want you to have *two* things to do at all times? Join Mike at the Mega Table to start into a second. You'll learn how to do cool\nand interesting things with Arrays and Hashes.\n\n[Exercises Repository](https://github.com/turingschool/ruby-exercises/tree/master/core-types)\n"
      expect(a.title).to eq "Array and Hash Exercises"
      expect(a.instructors).to eq [cjeff]
    end
  end

  require 'error_to_communicate/rspec_formatter'
  if $stdout.tty?
    RSpec.configure do |c|
      c.color     = true
      c.formatter = ErrorToCommunicate::RSpecFormatter
    end
  end

  RSpec.configuration.reporter.tap do |reporter|
    reporter.start 1
    integration_tests.run reporter
    reporter.finish
  end
end


unless defined? ActiveRecord
  require 'active_record'
  ActiveRecord::Base.establish_connection adapter: 'sqlite3', database: ':memory:'

  ActiveRecord::Schema.define do
    self.verbose = false
    define_schema(:sqlite)
  end

  define_models
  define_data
end
