namespace Tasks {

    public class BeforePickerView : Gtk.EventBox {
        
        private Gtk.Entry? entry;
        private Gtk.ComboBox? combo_box;
        private Gtk.ListStore list_store;
	    private Gtk.TreeIter iter;
	    
	    private bool is_enabled = false;
    	
    	public BeforePickerView() {
    		entry = new Gtk.Entry ();
            entry.set_text("0");
            entry.max_length = 2;
            entry.width_request = 50;
            entry.hexpand = false;
            entry.key_press_event.connect((key) => {
		    	if (key.keyval == 65288 || key.keyval == 65289 || (key.keyval >= 65456 && key.keyval <= 65465) || (key.keyval >= 48 && key.keyval <= 57)) {
		    		return false;
		    	}
		    	return true;
		    });
		    entry.get_style_context().add_class("before-field");
            
            list_store = new Gtk.ListStore (1, typeof (string));

	        list_store.append (out iter);
	        list_store.set (iter, 0, Strings.seconds_string);
	        list_store.append (out iter);
	        list_store.set (iter, 0, Strings.minutes_string);
	        list_store.append (out iter);
	        list_store.set (iter, 0, Strings.hours_string);
	        list_store.append (out iter);
	        list_store.set (iter, 0, Strings.days_string);

	        combo_box = new Gtk.ComboBox.with_model (list_store);
	        combo_box.set_state_flags (Gtk.StateFlags.INSENSITIVE, true);
	        combo_box.hexpand = true;
	        combo_box.get_style_context().add_class("type-selector");

	        Gtk.CellRendererText renderer = new Gtk.CellRendererText ();
	        combo_box.pack_start (renderer, true);
	        combo_box.add_attribute (renderer, "text", 0);
	        combo_box.active = 0;
            
            var grid2 = new Gtk.Grid ();
            grid2.orientation = Gtk.Orientation.HORIZONTAL;
            grid2.column_spacing = 8;
            grid2.add(entry);
            grid2.add(combo_box);
            grid2.get_style_context().add_class("date-time-field");
            
            add(grid2);
    	}
    	
    	public int64 get_seconds() {
            if (!is_enabled) {
                return 0;
            }
            if (entry == null || combo_box == null) {
                return 0;
            }
            Value val1;
	        combo_box.get_active_iter (out iter);
	        list_store.get_value (iter, 0, out val1);
	        
	        int64 input = (int64) int.parse (entry.get_text());
	        
	        int64 multiply = 0;
	        switch ((string) val1) {
	            case Strings.seconds_string:
	                multiply = 1;
	                break;
	            case Strings.minutes_string:
	                multiply = 60;
	                break;
	            case Strings.hours_string:
	                multiply = 60 * 60;
	                break;
	            case Strings.days_string:
	                multiply = 24 * 60 * 60;
	                break;
	        }
	        return input * multiply;
        }
    	
    	public void set_seconds(int64 seconds) {
    		var days = seconds / (60 * 60 * 24);
            if (days > 0) {
                entry.set_text(@"$days");
                combo_box.active = 3;
                return;
            }
            
            var hours = seconds / (60 * 60);
            if (hours > 0) {
                entry.set_text(@"$hours");
                combo_box.active = 2;
                return;
            }
            
            var minutes = seconds / (60);
            if (minutes > 0) {
                entry.set_text(@"$minutes");
                combo_box.active = 1;
                return;
            }
            
            entry.set_text(@"$seconds");
            combo_box.active = 0;
    	}
    	
    	public void set_enabled(bool enable) {
    	    this.is_enabled = enable;
    	    
    	    if (enable) {
                entry.set_state_flags (Gtk.StateFlags.NORMAL, true);
                combo_box.set_state_flags (Gtk.StateFlags.NORMAL, true);
            } else {
                entry.set_state_flags (Gtk.StateFlags.INSENSITIVE, true);
                combo_box.set_state_flags (Gtk.StateFlags.INSENSITIVE, true);
            }
    	}
    }
}
