namespace Tasks {

    public class TaskDialog : Gtk.Dialog {
    	
    	public TaskDialog(Gtk.Window parent, Event event) {
    	    this.title = event.summary;
		    this.border_width = 5;
		    set_default_size (250, 150);
		    
		    set_transient_for(parent);
		    
		    this.show_all ();
    	}
    }
}
