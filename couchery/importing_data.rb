# setup couch
require 'couchrest'

db = CouchRest.database!("http://127.0.0.1:5984/couchrest-test")

# create a view that allows querying google.events via the google_event_id
begin
  puts "PRE FIRST GUESS"
  db.get '_design/google'
  puts "POST FIRST GUESS"
rescue RestClient::ResourceNotFound
  db.save_doc(
    '_id' => "_design/google", # must be string, b/c that's how couchrest accesses it
    views: {
      events: {
        map: 'function(doc) { if (doc.type === "google.events") emit(doc.google_event_id, doc); }',
      },
    },
  )
end

# google.calendars
#   calendar_id
#   refresh token
#     # https://developers.google.com/accounts/docs/OAuth2
#     # Note: Save refresh tokens in secure long-term storage and continue to use them as long as they remain valid. Limits apply to the number of refresh tokens that are issued per client-user combination, and per user across all clients, and these limits are different. If your application requests enough refresh tokens to go over one of the limits, older refresh tokens stop working.

# google.attendees
#   id
#   email
#   display_name

# google.event
#   id
#   title (summary in the json)
#   calendar_id
#   location
#   html_link
#   google_event_id ('ojair...')
#   start_time (event.start_time # => 2015-02-13T07:00:00Z)
#   end_time

save_event = lambda do |event|
  # this "update or create" totally doesn't work, and I'm getting duplicate events :/
  view      = db.view 'google/events', key: event.id
  row       = view['rows'][0] || {}
  doc_attrs = row['value']    || {}

  # if it dne, create a new doc
  doc_attrs[:type]               = 'google.events'
  doc_attrs[:start_time]         = event.start_time   # eg "2015-02-13T07:00:00Z"
  doc_attrs[:end_time]           = event.end_time     # eg "2015-02-18T07:00:00Z"
  doc_attrs[:google_event_id]    = event.id           # eg "abc123"
  doc_attrs[:title]              = event.title        # eg "Welcome & Staff Intros"
  doc_attrs[:location]           = event.location
  doc_attrs[:calendar_html_link] = event.html_link    # eg "https://www.google.com/calendar/event?eid=dTFhYjAzMzJuYjNkYTdna282aTVuZnU4MGMgY2FzaW1pcmNyZWF0aXZlLmNvbV81OWs4bXNycmMyZGRoY3Y3ODd2dWJ2cDBzNEBn"
  doc_attrs[:calendar_id]        = '??'               # going to need to get this off the key we created the db with, it doesn't seem to store this

  # this is probably wrong, b/c its directly saving google calendar json in our db as if its our document
  doc_attrs[:attendees]          = event.attendees    # => [{"email"=>"team@turing.io",
                                                       #      "displayName"=>"Turing Team",
                                                       #      "responseStatus"=>"needsAction"
                                                       #    }]

  response  = db.save_doc(doc_attrs)
  couch_doc = db.get(response['id'])
  couch_doc
end


# setup google calendar
require 'google_calendar'

# to get these env vars, source set_env.fish
cal = Google::Calendar.new :client_id     => ENV['GOOGLE_CLIENT_ID'],
                           :client_secret => ENV['GOOGLE_CLIENT_SECRET'],
                           :calendar      => ENV['GOOGLE_CALENDAR_ID'],
                           :redirect_url  => "http://localhost:3000" # this is what Google uses for 'applications'

cal.login_with_refresh_token(ENV['GOOGLE_REFRESH_TOKEN'])
calendar_events = cal.find_events_in_range Date.today.to_time, (Date.today + 1).to_time

calendar_events.each do |calendar_event|
  couch_event = save_event.call calendar_event
end
