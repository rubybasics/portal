# setup couch
require 'couchrest'
db = CouchRest.database!("http://127.0.0.1:5984/couchrest-test")

# setup google calendar
require 'google_calendar'

# to get these env vars, source set_env.fish
cal = Google::Calendar.new :client_id     => ENV['GOOGLE_CLIENT_ID'],
                           :client_secret => ENV['GOOGLE_CLIENT_SECRET'],
                           :calendar      => ENV['GOOGLE_CALENDAR_ID'],
                           :redirect_url  => "http://localhost:3000" # this is what Google uses for 'applications'

cal.login_with_refresh_token(ENV['GOOGLE_REFRESH_TOKEN'])

events = cal.find_events_in_range Date.today.to_time, (Date.today + 1).to_time
event  = events.first
event.start_time   # => "2015-02-13T07:00:00Z"
event.end_time     # => "2015-02-18T07:00:00Z"
event.id           # => "abc123"
event.attendees    # => [{"email"=>"team@turing.io",
                   #      "displayName"=>"Turing Team",
                   #      "responseStatus"=>"needsAction"
                   #    }]
event.transparency # => "transparent"
event.status       # => "confirmed"
event.title        # => "Welcome & Staff Intros"
event.location     # => nil
require "pry"
binding.pry
exit!
# create
response = @db.save_doc({:key => 'value', 'another key' => 'another value'})
# {"ok"=>true, "id"=>"e0d70033da0fad3707fed320bd5e5de2", "rev"=>"1-cbb61d1f90f7c01b273737702265b6c8"}

# fetch by id
doc = @db.get(response['id'])
# #<CouchRest::Document _id: "e0d70033da0fad3707fed320bd5e5de2", _rev: "1-cbb61d1f90f7c01b273737702265b6c8", key: "value", another key: "another value">

# update
doc["boogie"] = true
@db.save_doc(doc)
# {"ok"=>true, "id"=>"e0d70033da0fad3707fed320bd5e5de2", "rev"=>"2-3b067cc9f01fdf25814445088403382c"}

doc["_rev"]
# "2-3b067cc9f01fdf25814445088403382c" <- notice it modified the doc _rev

require 'pry'
binding.pry
