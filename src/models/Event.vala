namespace Tasks {
	public class Event : Object {
	
		public const int DATE = 0;
		public const int TIMER = 1;
		
		public int64 id { get; set; default = 0; }
		public int64 year { get; set; default = 0; }
		public int64 month { get; set; default = 0; }
		public int64 day { get; set; default = 0; }
		public int64 hour { get; set; default = 0; }
		public int64 minute { get; set; default = 0; }
		public int64 second { get; set; default = 0; }
		public int64 event_type { get; set; default = 0; }
		public int64 timer_time { get; set; default = 0; }
		public string summary { get; set; default = ""; }
		public string description { get; set; default = ""; }
		public bool is_active { get; set; default = true; }
		public bool has_reminder { get; set; default = false; }
		public bool show_notification { get; set; default = false; }
		
		public bool isSelected { get; set; default = false; }

		public Event() {
			this.with_id(0, "", "");
		}

		public Event.with_id(int64 id, string summary, string description) {
		  	this.id = id;
		  	this.summary = summary;
		  	this.description = description;
		}
		
		public Event.with_event(Event event) {
		  	this.year = event.year;
            this.month = event.month;
            this.day = event.day;
            this.hour = event.hour;
            this.minute = event.minute;
            this.event_type = event.event_type;
            this.is_active = event.is_active;
            this.has_reminder = event.has_reminder;
            this.show_notification = event.show_notification;
            this.timer_time = event.timer_time;
            this.summary = event.summary;
            this.description = event.description;
		}

		public string to_string() {
		  	return @"Event => id: $id, summary: $summary, desc: $description, type: $event_type, has_reminder: $has_reminder";
		}
  	}
}
