namespace Tasks {
	public class Event : Object {
	
		public const int DATE = 0;
		public const int TIMER = 1;
		
		public uint id { get; set; default = 0; }
		public int64 event_type { get; set; default = 0; }
		public int64 timer_time { get; set; default = 0; }
		public int64 estimated_time { get; set; default = 0; }
		public int64 due_date_time { get; set; default = 0; }
		public int64 before_time { get; set; default = 0; }
		public string summary { get; set; default = ""; }
		public string description { get; set; default = ""; }
		public bool is_active { get; set; default = true; }
		public bool has_reminder { get; set; default = false; }
		public bool show_notification { get; set; default = false; }
		
		public bool isSelected { get; set; default = false; }

		public Event() {
			this.with_id(0, "", "");
		}

		public Event.with_id(uint id, string summary, string description) {
		  	this.id = id;
		  	this.summary = summary;
		  	this.description = description;
		}
		
		public Event.with_event(Event event) {
		  	this.due_date_time = event.due_date_time;
            this.event_type = event.event_type;
            this.is_active = event.is_active;
            this.has_reminder = event.has_reminder;
            this.show_notification = event.show_notification;
            this.timer_time = event.timer_time;
            this.summary = event.summary;
            this.description = event.description;
            this.estimated_time = event.estimated_time;
            this.before_time = event.before_time;
		}
		
		public Event.full_copy(Event event) {
		  	this.id = event.id;
		  	this.due_date_time = event.due_date_time;
            this.event_type = event.event_type;
            this.is_active = event.is_active;
            this.has_reminder = event.has_reminder;
            this.show_notification = event.show_notification;
            this.timer_time = event.timer_time;
            this.summary = event.summary;
            this.description = event.description;
            this.estimated_time = event.estimated_time;
            this.before_time = event.before_time;
            this.isSelected = event.isSelected;
		}

		public string to_string() {
		  	return @"Event => id: $id, summary: $summary, desc: $description, type: $event_type, has_reminder: $has_reminder, is_active: $is_active";
		}
  	}
}
