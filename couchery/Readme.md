Notes
=====

Stats:
------

```
config.ru
  test Portal::LoadEnv.call(ENV) # => {calendars: [GoogleCalendar], db: CouchRest}
  loads env vars, sets env[:calendars] = PortalDependencies.calendars
```


- [ ] Import data from Google Calendar
  - [ ] authenticate all calendars
  - [x] Can set events into couch db
  - [ ] Track calendars via env var and table
  - [ ] Track attendees as an array of email addresses
- [ ] Translate into an internal representation
- [ ] idk, figure out more shit


Installing CouchDb
------------------

```sh
$ brew install couchdb               # install (I have 1.6.1)
$ couchdb -b 					               # start in bg
$ curl http://127.0.0.1:5984/        # test it
$ open http://localhost:5984/_utils/ # the web interface
```

Gem
---

[couchrest](https://rubygems.org/gems/couchrest)

It has a [wiki](https://github.com/couchrest/couchrest/wiki)
