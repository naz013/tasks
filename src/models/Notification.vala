namespace Tasks {
	public class Notification : Object {
		public uint id { get; set; default = 0; }
		public int64 time { get; set; default = 0; }
		public string summary { get; set; default = ""; }
		
		public Notification(uint id, string summary, int64 time) {
		  	this.id = id;
		  	this.summary = summary;
		  	this.time = time;
		}
	}
}
