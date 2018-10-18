namespace Tasks {

    public class TimerView : Gtk.EventBox {
        
        private Gtk.Entry entry;
        private Gtk.Button label;
        
        private string input = "";
        private string re_presentation = "";
    	
    	public TimerView() {
    	    var overlay = new Gtk.Overlay();
    	    overlay.height_request = 40;
    	    overlay.hexpand = true;
    	    overlay.vexpand = false;
    	    
    	    entry = new Gtk.Entry ();
		    entry.set_max_length(1);
		    entry.has_frame = false;
		    entry.editable = false;
		    entry.caps_lock_warning = false;
		    entry.set_visibility(false);
		    entry.set_opacity(0);
		    entry.key_press_event.connect((key) => {
		    	var str = key.str;
		    	Logger.log(@"Input value -> $(key.str), is_mod -> $(key.is_modifier), val -> $(key.keyval)");
		    	if (key.keyval == 65288) {
		    		remove_digit();
		    	} else if (key.keyval == 65289) {
		    		entry.is_focus = false;
		    	} else if (key.keyval >= 65456 && key.keyval <= 65465) {
		    		add_digit(str);
		    	}
		    	return true;
		    });
		    entry.get_style_context().add_class("invisible_view");
		    
		    overlay.add(entry);
		    
		    label = new Gtk.Button.with_label("00H 00m 00s");
		    label.height_request = 40;
		    label.hexpand = true;
		    label.get_style_context().add_class(CssData.MATERIAL_BUTTON_FLAT);
		    label.get_style_context().add_class("timer_label");
		    label.clicked.connect (() => {
                entry.grab_focus_without_selecting();
                Logger.log("Timer touched");
            });
            create_label();
		    
		    overlay.add_overlay(label);
		    
		    entry.is_focus = true;
		    
		    overlay.show_all();
    	    add(overlay);
    	}
    	
    	public int64 get_seconds() {
    		return Utils.to_seconds(input);
    	}
    	
    	public void set_seconds(int64 seconds) {
    	    input = Utils.from_seconds(seconds);
    		create_label();
    	}
    	
    	private void add_digit(string digit) {
    		if (input.length >= Utils.LENGTH) {
    			return;
    		}
    		input = input + digit;
    		create_label();
    	}
    	
    	private void create_label() {
    		re_presentation = Utils.to_label(input);
    		Logger.log(@"create_label: re_p -> $re_presentation");
    		label.set_label(re_presentation);
    	}
    	
    	private void remove_digit() {
    		if (input.length == 0) {
    			return;
    		}
    		input = input.substring(0, input.length - 1);
    		create_label();
    	}
    }
}
