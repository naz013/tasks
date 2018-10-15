namespace Tasks {
	public class Event : Object {
	
		public static const int DATE = 0;
		public static const int TIMER = 1;
		
		public int id { get; set; default = 0; }
		public int year { get; set; default = 0; }
		public int month { get; set; default = 0; }
		public int day { get; set; default = 0; }
		public int hour { get; set; default = 0; }
		public int minute { get; set; default = 0; }
		public int second { get; set; default = 0; }
		public int event_type { get; set; default = 0; }
		public long timer_time { get; set; default = 0; }
		public string summary { get; set; default = ""; }
		public string description { get; set; default = ""; }
		public bool is_active { get; set; default = true; }
		public bool has_reminder { get; set; default = false; }
		
		public bool isSelected { get; set; default = false; }

		public Event() {
			this.with_id(0, "", "");
		}

		public Event.with_id(int id, string summary, string description) {
		  	this.id = id;
		  	this.summary = summary;
		  	this.description = description;
		}

		public string to_string() {
		  	return @"Event => id: $id, summary: $summary, type: $event_type, has_reminder: $has_reminder";
		}
  	}
}
