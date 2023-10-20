var app = Application("Calendar");

app.includeStandardAdditions = true;

var now = new Date();
var oneHourLater = new Date(now);
oneHourLater.setHours(now.getHours() + 1); // Adjust the time window as needed

var calendars = app.calendars.whose({ name: "Work" }); // Replace with your calendar name

if (calendars.length === 0) {
  "ERROR_CALENDAR_NOT_FOUND"
}

var currentCalendar = calendars[0];
var currentEvents = currentCalendar.events.whose({
  startDate: { "<=": oneHourLater },
  endDate: { ">": now },
});

var currentEvent = currentEvents[0];
var summary = currentEvent.summary();
// FIXME: this times out...
summary;

// "No current events within the next hour";
