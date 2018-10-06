namespace Tasks {
  public class ListEvent : Object {

    public string id { get; set; default = "000"; }
    public string summary { get; set; default = ""; }
    public string description { get; set; default = ""; }
    public bool isSelected { get; set; default = false; }

    public ListEvent() {
      this.with_id("000", "", "");
    }

    public ListEvent.with_id(string id, string summary, string description) {
      this.id = id;
      this.summary = summary;
      this.description = description;
    }

    public ListEvent.with_event(Event event) {
      this.id = event.id;
      this.summary = event.summary;
      this.description = event.description;
    }

    public string to_string() {
      return "ListEvent => id: $id, summary: $summary, description: $description";
    }
  }
}
