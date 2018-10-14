namespace Tasks {

    public class TimerView : Gtk.EventBox {
    	
    	private const string ZERO = "0";
    	private const int LENGTH = 6;
    	private const long MINUTE = 60;
    	private const long HOUR = MINUTE * 60;
        
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
		    
		    overlay.add_overlay(label);
		    
		    entry.is_focus = true;
		    
		    overlay.show_all();
    	    add(overlay);
    	}
    	
    	public long get_seconds() {
    	    var tmp = "";
    		if (input.length < LENGTH) {
    			for (int i = 0; i < LENGTH - input.length; i++) {
    				tmp = tmp + ZERO;
    			}
    		}
    		tmp = tmp + input;
    		
    		var d01 = tmp.substring(0, 2);
    		var d23 = tmp.substring(2, 2);
    		var d45 = tmp.substring(4, 2);
    		
    		long secs = 0;
    		secs += int.parse(d01) * HOUR;
    		secs += int.parse(d23) * MINUTE;
    		secs += int.parse(d45);
    		
    		Logger.log(@"get_seconds: tmp -> $tmp, secs -> $secs");
    		
    		return secs;
    	}
    	
    	public void set_seconds(long seconds) {
    	    var hours = seconds / HOUR;
    	    var minutes = (seconds - (hours * HOUR)) / MINUTE;
    	    var secs = (seconds - (hours * HOUR) - (minutes * MINUTE));
    	    var tmp = "";
    	    if (hours > 0){
    	        tmp = tmp + @"$(hours)";
    	    }
    	    if (tmp.length > 0) {
    	        if (minutes < 10) {
        	        tmp = tmp + @"0$(minutes)";
        	    } else {
        	        tmp = tmp + @"$(minutes)";
        	    }
    	    } else {
    	        tmp = tmp + @"$(minutes)";
    	    }
    	    if (tmp.length > 0) {
    	        if (secs < 10) {
        	        tmp = tmp + @"0$(secs)";
        	    } else {
        	        tmp = tmp + @"$(secs)";
        	    }
    	    } else {
    	        tmp = tmp + @"$(secs)";
    	    }
    	    
    	    input = tmp;
    		create_label();
    	}
    	
    	private void add_digit(string digit) {
    		if (input.length >= LENGTH) {
    			return;
    		}
    		input = input + digit;
    		create_label();
    	}
    	
    	private void create_label() {
    		var tmp = "";
    		if (input.length < LENGTH) {
    			for (int i = 0; i < LENGTH - input.length; i++) {
    				tmp = tmp + ZERO;
    			}
    		}
    		tmp = tmp + input;
    		Logger.log(@"create_label: tmp -> $tmp");
    		
    		var d01 = tmp.substring(0, 2);
    		var d23 = tmp.substring(2, 2);
    		var d45 = tmp.substring(4, 2);
    		
    		re_presentation = @"$(d01)H $(d23)m $(d45)s";
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
