namespace Tasks {
  public class Event : Object {

    public string id { get; set; default = "000"; }
    public string summary { get; set; default = ""; }
    public string description { get; set; default = ""; }

    public Event() {
      this.with_id("000", "", "");
    }

    public Event.with_id(string id, string summary, string description) {
      this.id = id;
      this.summary = summary;
      this.description = description;
    }

    public Event.with_event(ListEvent event) {
      this.id = event.id;
      this.summary = event.summary;
      this.description = event.description;
    }

    public string to_string() {
      return "Event => id: $id, summary: $summary, description: $description";
    }
  }
}
