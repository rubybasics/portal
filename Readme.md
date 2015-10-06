Turingschool Portal
===================

* Hosted at: [http://portal.turing.io/](http://portal.turing.io/).
* Trello board: [https://trello.com/c/2GqFLjJW/7-turing-portal](https://trello.com/c/2GqFLjJW/7-turing-portal)

Currently, it only authenticates users (ie no content yet).

TODO
----

* today.turing.io
  * Portal: Serve the data in an API (integration test)
  * today-json: probably put the code here
  * today.turing.io:
    * pull the code in and generate content
    * make sure we can handle API days and pre-existing markdown days
* Portal
  * Expose an admin interface for updating the data
  * Don't spend much time on students / cohorts,
  * b/c we prob want that from enroll
* Pull data from Enroll
* Add student schedules to Portal
* Add attendance to Portal

Things to remember when making content:
---------------------------------------

* Holistic understanding
  * For each feature, a student should understand why they are doing a thing,
    or why it is available. e.g. a link on quizzes explaining why quizzes are a thing,
    how to use them, what they should get out of them
* Productive outlet for frustration
  * For each feature, a student should have a productive way to channel their frustration.
    E.g. a link to edit material, a link to report problems.

Dump of notes Josh had written down for things I want to do:
------------------------------------------------------------

```
portal
  aggregate all our apps in one place
    either mounted on subdirs or consumed as services and the interface presented on subdirs
  integration
    assessment information
      currently this is a git repo, we put info there and then nothing really happens with it.
      with this, a students history would be much more accessible (to us and to them)
    feedback for and from students
      e.g. Rachel's questions, aggregated in one place, presented in a way that makes the data easier to undrestand the patterns at play
      this would be the basis of measuring our success and identifying areas for improvement
    portfolio
      integrate it here rather than having it be a separate service (or consume the separate service)
    standards
      add interfaces for students to browse them
      for admin to edit them
    bring in today.turing.io
      generate it from some canonical data source
      so we can start cross-referencing with standards and lesson plans
      Students can then scope material to just what pertains to them
      Rachel can generate the material she places into the mentor emails
    enroll
      prep for students paying us back
      make sure we're ready for when Stripe comes out of beta
  start investing in learning tools:
    quizzes
      we can make them to reinforce a lesson
      students can make them, which helps empower them to take charge of their own learning
      helps readdress information that was missed
      can be associated to relevant standards
        so that a student can read a standard and try all the quiz-lessons that pertain to it
        to gain confidence and identify areas of weakness
    "sparks"
      a place to write down ideas that spark their excitement
      so that when Fridays roll around, they're eager to apply that open time to one of their ideas
      hopefully helps us achieve an intense learning environment
        I expect imposing it to do much more harm than good
        but with this approach, their own excitement and motivation drives the behaviour
      maybe a few topic ideas to get the wheels in their brain turning, e.g.
        What would make the space mroe enjoyable to be in
        What would make this week's material better for future groups?
        What would might be another interesting way to address a problem from your last project?
    cheatsheets
      Get them taking notes in a way they can reference back to later,
      share with others (builds community, gives them a reason to be excited about studying, as this is what they are doing when they make cheatsheets)
      make our jobs easier by supplementing our material
    MOI
      Not exactly sure what I want for this yet, but it has a lot of promise
      Jonmichael is adding docker to it, which gives us the power to add our own gems/databases/etc
      We could possibly hook it up to quizzes
      or possibly be able to tackle most topics in it
      such that they are interactive in a way that a student can trivially come back and go through them again
      If they're reviewing something, they read about it, and there's an inviting text editor right there with some code in it...
      well, they'd almost have to try *not* to play with the idea again.
    Object Model Viewer
      I'm pretty confident that this is the biggest reason students struggle during the first 3 months
      And without adding redundant lessons, I'm pretty sure I'm approaching the extent of what I can accomplish with a lesson
    Exercism
      Great resource, if it has an API, we could pull it in and display their completion rate in a gameified sort of way
      Give them an extra reason to keep working on these
    Github
      When students submit issues and pulls to us, this is super awesome, we need to encourage it
      It is a way for them to take a problem and do something about it.
      It's hard right now to track this, though, because noise vs spam
      But it should be pretty easy to integrate with github to see a list of open issues/pulls, and aggregate them in one easy to identify place,
      allowing us to keep on top of this to grow this kind of behaviour rather than neglecting it until it does (Steve is doing an awesome job at keeping on top of this stuff so far, but shouldn't all be on him, but it takes a lot of effort for anyone else to pitch in)
    Very fine-grained interactive lessons
      I think many of the students who struggle do so because they haven't learned to learn yet,
      and haven't begun to internalize the patterns or develop a model yet
      Currently, students in this situation are going to struggle and possibly fail
      With sufficient tools, we have the possibility of giving them short, highly focused, always available lessons
      that will likely be as (if not more) valuable than sitting down with them 1-on-1
      and scale to all future students, and depending on how effective it is, possibly beyond that.

      Students will have me remove a hurdle from in front of them,
      but then not stop to understand how I knew what to do or why they didn't.
      These gaps sometimes deal with not understanding the smaller picture
      and sometimes with not understanding the bigger picture.
      That's fucking scary.
      It will undermine the foundation that supports everything else they learn.
      They will struggle ten times more than they need to, learn ten times less, be unhappy, demotivated, and only moderately competent

      I think this is the most important thing we need to address for our students.
      With a tool like this (and I don't know what it looks like, it might just be a particular style and application of interactive quizzes)
      we could give them the opportunity to go back to material that went over their heads, and then come to deeply understand it.
      More than the opportunity, though, the inevitability -- because our students all work hard, they just don't all work effectively.
      The purpose of this is to help them focus their efforts.
```
