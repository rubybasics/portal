Quick way to access the user repo while you're just messing around

```ruby
user_repository = Deject.registered(:user_repository).call
```

Authenticating with Google calendar (you'll need to set these keys)

```ruby
require 'google_calendar'

# Create an instance of the calendar.
cal = Google::Calendar.new :client_id     => ENV['GOOGLE_CLIENT_ID'],
                           :client_secret => ENV['GOOGLE_CLIENT_SECRET'],
                           :calendar      => ENV['CALENDAR_ID'],
                           :redirect_url  => "http://localhost:3000" # this is what Google uses for 'applications'

puts "Do you already have a refresh token? (y/n)"
has_token = $stdin.gets.chomp

if has_token.downcase != 'y'
  # A user needs to approve access in order to work with their calendars.
  puts "Visit the following web page in your browser and approve access."
  puts cal.authorize_url
  puts "\nCopy the code that Google returned and paste it here:"

  # Pass the ONE TIME USE access code here to login and get a refresh token that you can use for access from now on.
  refresh_token = cal.login_with_auth_code( $stdin.gets.chomp )

  puts "\nMake sure you SAVE YOUR REFRESH TOKEN so you don't have to prompt the user to approve access again."
  puts "your refresh token is:\n\t#{refresh_token}\n"
  puts "Press return to continue"
  $stdin.gets.chomp

else
  puts "Enter your refresh token"
  refresh_token = $stdin.gets.chomp
  cal.login_with_refresh_token(refresh_token)

  # Note: You can also pass your refresh_token to the constructor and it will login at that time.

end

# event = cal.create_event do |e|
#   e.title = 'A Cool Event'
#   e.start_time = Time.now
#   e.end_time = Time.now + (60 * 60) # seconds * min
# end
# puts event

# event = cal.find_or_create_event_by_id(event.id) do |e|
#   e.title = 'An Updated Cool Event'
#   e.end_time = Time.now + (60 * 60 * 2) # seconds * min * hours
# end
# puts event

# All events
events = cal.find_events_in_range (Date.today - 3).to_time, (Date.today + 5).to_time
require "pry"
binding.pry

# # Query events
# puts cal.find_events('your search string')
```

Getting event data from the calendar

```ruby
events = cal.find_events_in_range (Date.today - 3).to_time, (Date.today + 5).to_time
e = events.first
e.start_time
# => "2015-02-13T07:00:00Z"

e.end_time
# => "2015-02-18T07:00:00Z"

e.id
# => "abc123"

e.attendees
# => [{"email"=>"team@turing.io",
# "displayName"=>"Turing Team",
# "responseStatus"=>"needsAction"}]

e.transparency
# => "transparent"

e.status
# => "confirmed"

e.title
# => "Welcome & Staff Intros"

e.location
# => nil

puts e.to_json
{
        "summary": "Welcome & Staff Intros",
        "description": "",
        "location": "",
        "start": {
          "dateTime": "2015-02-09T15:30:00Z"
        },
        "end": {
          "dateTime": "2015-02-09T16:00:00Z"
        },
        "attendees": [
{
          "displayName": "Turing Team",
          "email": "team@turing.io",
          "responseStatus": "needsAction"
        }],
        "reminders": {
          "useDefault": true
        }
      }
```

Hypothetical schema

```
ENV vars
  GOOGLE_CLIENT_ID
  GOOGLE_EMAIL_ADDRESS
  GOOGLE_CLIENT_SECRET

google.calendars
  calendar_id
  refresh token
    # https://developers.google.com/accounts/docs/OAuth2
    # Note: Save refresh tokens in secure long-term storage and continue to use them as long as they remain valid. Limits apply to the number of refresh tokens that are issued per client-user combination, and per user across all clients, and these limits are different. If your application requests enough refresh tokens to go over one of the limits, older refresh tokens stop working.

google.attendees
  id
  email
  display_name

google.event
  id
  title (summary in the json)
  calendar_id
  location
  html_link
  google_event_id ('ojair...')
  start_time (event.start_time # => 2015-02-13T07:00:00Z)
  end_time

cached_users
  user_id  # identity primary token, use as primary token here
  email    # cached from identity
  name     # cached from identity
  is_admin

cached_cohort
  id
  name ("All", "1502", etc)

cohorts_users
  group_id
  user_id

attendees_to_users
  user_id
  google_calendar_user_id

today.day
  id
  date

today.cohort_section
  day_id
  cohort_id

today.cohort_sections_to_users
  user_id
  cohort_section_id

today.activity
  cohort_section_id
  title
  start_time
  end_time
  location
  description (markdown text)

today.activities_to_instructors
  activity_id
  user_id (look up attendees in google calendar,
           this is that association -- the instructor
           assigned to that lesson)
```
