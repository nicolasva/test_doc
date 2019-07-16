# README

rake db:create
rake db:migrate
rake db:seed

## Technical Test @ Doctolib

The goal is to write an algorithm that finds availabilities in an agenda depending on the events attached to it.
The main method has a start date for input and is looking for the availabilities over the next 7 days.

There are two kinds of events:

 - 'opening', are the openings for a specific day and they can be reccuring week by week.
 - 'appointment', times when the doctor is already booked.

To init the project:

``` sh
rails new doctolib-test
rails g model event starts_at:datetime ends_at:datetime kind:string weekly_recurring:boolean
```

Your Mission:
 - coded for rails 5.1
 - contained in two files named event.rb and event_test.rb
 - must pass the unit tests below
 - add tests for edge cases
 - be pragmatic about performance
 - read our values : https://careers.doctolib.fr/engineering/
