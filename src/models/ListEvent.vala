namespace Tasks {
  public class ListEvent : Object {

    public int id { get; set; default = 0; }
    public int year { get; set; default = 0; }
    public int month { get; set; default = 0; }
    public int day { get; set; default = 0; }
    public int hour { get; set; default = 0; }
    public int minute { get; set; default = 0; }
    public int second { get; set; default = 0; }
    public string summary { get; set; default = ""; }
    public string description { get; set; default = ""; }
    public bool isSelected { get; set; default = false; }

    public ListEvent() {
      this.with_id(0, "", "");
    }

    public ListEvent.with_id(int id, string summary, string description) {
      this.id = id;
      this.summary = summary;
      this.description = description;
    }

    public ListEvent.with_event(Event event) {
      this.id = event.id;
      this.summary = event.summary;
      this.description = event.description;
      this.year = event.year;
      this.month = event.month;
      this.day = event.day;
      this.hour = event.hour;
      this.minute = event.minute;
      this.second = event.second;
    }
  }
}
