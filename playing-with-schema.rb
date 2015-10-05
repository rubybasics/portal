require 'active_record'
ActiveRecord::Base.establish_connection adapter: 'sqlite3', database: ':memory:'
ActiveRecord::Schema.define do
  self.verbose = false

  atype = :string
  # atype = :activity_type
  # connection.execute "CREATE TYPE activity_type AS ENUM ('daily_fact');"

  create_table :activities do |t|
    t.column :activity_type, atype
    t.text   :content
    t.datetime :start
    t.datetime :finish
  end

  create_table :activities_to_cohorts do |t|
    t.integer :activity_id
    t.integer :cohort_id
  end

  status_type = :string
  # status_type = :status_type
  # connection.execute "CREATE TYPE status_type AS ENUM ('pending', 'current', 'graduated');"

  create_table :cohorts do |t|
    t.string :name
    t.column :status, status_type
  end
end

class Activity < ActiveRecord::Base
  has_many :activities_to_cohorts, class_name: 'ActivityToCohort'
  has_many :cohorts, through: :activities_to_cohorts
end

class ActivityToCohort < ActiveRecord::Base
  self.table_name = 'activities_to_cohorts'
  belongs_to :activity
  belongs_to :cohort
end

class Cohort < ActiveRecord::Base
  has_many :activities_to_cohorts, class_name: 'ActivityToCohort'
  has_many :activities, through: :activities_to_cohorts
  def self.current
    where status: :current
  end
end

c1510 = Cohort.create! name: '1510', status: :pending
c1508 = Cohort.create! name: '1508', status: :current
c1507 = Cohort.create! name: '1507', status: :current
c1505 = Cohort.create! name: '1505', status: :current
c1503 = Cohort.create! name: '1503', status: :current
c1502 = Cohort.create! name: '1502', status: :graduated

date = Time.parse '2015-08-26'

define_method :at do |hours, minutes=0|
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
  a.content       = <<-MARKDOWN
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




__END__

## 1503

## Exercise -- SuperFizz in JS (9:00 - 9:30)

Start the day off right by joining Horace in classroom C to write
a variant of FizzBuzz, [SuperFizz](https://github.com/turingschool/challenges/blob/master/super_fizz.markdown).

## Full-Stack Integration Testing with Selenium (9:30 - 12:00)

Join Horace in Classroom C to practice working with Selenium,
a browser driver for Capybara which let's us write integration
tests which actually exercise our JS code as well!

[Lesson](https://github.com/turingschool/lesson_plans/blob/master/ruby_04-apis_and_scalability/full_stack_integration_testing_with_selenium.markdown)

For one section of this lesson, we'll do some work in pairs:

* Margarett Ly & Drew Reynolds
* Max Tedford & Vanessa Gomez
* Whitney Hiemstra & Sally MacNicholas
* Morgan Miller & Justin Holmes
* Brett Grigsby & Josh Cass

## Project Work Time and Check-Ins (1:00 - 4:00)

### With Horace

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

## 1505

### Multi-Tenancy Authorization (9:00 - 12:00)

Learn about how to manage different user permissions using a service object.

Before the class, please clone the lesson repo using the following command:

```
git clone -b multitenancy_authorization https://github.com/turingschool-examples/storedom.git multitenancy_authorization
```

The materials for this lesson are the following:

* [Notes](https://www.dropbox.com/s/xebujx48iaf3vwl/Turing%20-%20Multitenancy%20Authorization%20%28Notes%29.pages?dl=0)
* [Lesson Plan](https://github.com/turingschool/lesson_plans/blob/master/ruby_03-professional_rails_applications/multitenancy_authorization.markdown)
* [Video](https://vimeo.com/137451107)

Big Workspace with Jorge.

### Project Work Time (1:00 - 4:00)

Work on your Pivot projects with your teams. Remember to focus on your user stories. Iteration 1 is due on Thursday afternoon.

Andrew will be available for questions.

## 1507

### CRUD Homework Review (9:00 - 9:30)

Classroom B with Josh.

### Model Testing in Sinatra (9:30 - 12:00)

Still in Classroom B with Josh.

[Lesson Plan](https://github.com/turingschool/lesson_plans/blob/master/ruby_02-web_applications_with_ruby/model_testing_in_sinatra.markdown)

### Nokogiri (1:00 - 1:30)

You will find yourself again with Josh in Classroom B.

Enjoy this [challenge](https://github.com/turingschool/challenges/blob/master/parsing_html.markdown).

### Acceptance Testing with Capybara (1:30 - 4:00)

Classroom B for DAYS.

[Lesson Plan](https://github.com/turingschool/lesson_plans/blob/master/ruby_02-web_applications_with_ruby/feature_testing_in_sinatra_with_capybara.markdown)


## 1508

### All - Introducing Arrays (9:00 - 10:30) and Introducing Hashes (10:30 - 12:00)

Classroom A with Jeff to [learn about arrays and hashes](https://github.com/turingschool/lesson_plans/blob/master/ruby_01-object_oriented_programming_with_ruby/arrays_and_hashes.markdown).

### Echo - How Testing Works (1:00 - 2:30)

Join Josh Cheek at the front of Classoom A.

We'll be working in this repository: [https://github.com/JoshCheek/how-to-test](https://github.com/JoshCheek/how-to-test).

Make sure you know how to run programs in the shell, and have the keybindings
[https://github.com/JoshCheek/1508/blob/3de9c9729481c59bcebc6f30b4f10ea52ed5d36c/shell.md#keybindings](https://github.com/JoshCheek/1508/blob/3de9c9729481c59bcebc6f30b4f10ea52ed5d36c/shell.md#keybindings).
I'm going to make you show the person adjacent to you before we go onto this stuff
(the last time I gave this lesson, it took 8 minutes to edit a file, I don't want to lose that kind of time anymore).
If you're not confident you can do those things, take 10 min during your lunch and refresh yourself.

### Echo - Sorting Suite Kickoff (2:30 - 3:00)

Stay at the front of Classroom A for sorting algorithms, y'all [https://vimeo.com/channels/sortalgorithms](https://vimeo.com/channels/sortalgorithms).

First project, [Sorting Suite](https://github.com/turingschool/sorting-suite).

This is a project with a grading matrix.
It is due 9AM on Monday.
You will work independently (ie you will each have your own, but you can confer with other students... confer != share code)
For planning purposes, our guess is that this will take you in the range of 20 hrs.


### Echo - Intro to TDD Tutorial (3:00 - 4:00)

Big Surprise, you are in the front of Classroom A.

Work independently on [this Intro to TDD tutorial](http://tutorials.jumpstartlab.com/topics/testing/intro-to-tdd.html).
We'll make a few changes, such as using [mrspec](https://rubygems.org/gems/mrspec)
to run our tests, but other than that, follow along, as described.

### Echo - Homework

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

### Foxtrot - SuperFizz Recap (1:00 - 1:30)

Join Jeff at the Mega Table.

### Foxtrot - Mastermind Kickoff (1:30 - 2:00)

It's time to start your first project, [Mastermind](https://github.com/turingschool/curriculum/blob/master/source/projects/mastermind.markdown). Meet Jeff at the Mega Table to discuss and plan.

### Foxtrot - Array and Hash Exercises (2:00 - 4:00)

Remember when we said we want you to have *two* things to do at all times? Join Mike at the Mega Table to start into a second. You'll learn how to do cool
and interesting things with Arrays and Hashes.

[Exercises Repository](https://github.com/turingschool/ruby-exercises/tree/master/core-types)
