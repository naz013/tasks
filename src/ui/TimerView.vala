namespace Tasks {

    public class TimerView : Gtk.EventBox {
    
        delegate void IntType (int val);
        
        private Gtk.Label label;
        private Gtk.Popover? popover;
        
        private int seconds = 0;
        private int hours = 0;
        private int minutes = 0;
        private string re_presentation = "";
    	
    	public TimerView() {
		    var timer_field = new Gtk.Grid();
		    timer_field.hexpand = true;
		    timer_field.orientation = Gtk.Orientation.HORIZONTAL;
		    timer_field.get_style_context().add_class("date-time-field");
		    
		    label = new Gtk.Label("");
		    label.set_xalign(0.0f);
		    label.hexpand = true;
		    label.get_style_context().add_class(CssData.LABEL_SECONDARY);
		    
            create_label();
            timer_field.add(label);
            
            var date_button = new Gtk.Button.from_icon_name ("tools-timer-symbolic", Gtk.IconSize.BUTTON);
            date_button.has_tooltip = false;
            date_button.hexpand = false;
            date_button.set_always_show_image(true);
            date_button.get_style_context().add_class("icon_button");
            date_button.clicked.connect (() => {
                show_picker(date_button);
            });
            
            timer_field.add(date_button);
    	    add(timer_field);
    	}
    	
    	private void show_picker(Gtk.Widget parent) {
            Gtk.Grid time_grid = new Gtk.Grid();
		    time_grid.column_spacing = 4;
		    time_grid.orientation = Gtk.Orientation.HORIZONTAL;
		    
		    var seconds_view = create_spin_button(0, 99, 1, (val) => {
			    seconds = val;
			    create_label();
		    });
		    
		    var hours_view = create_spin_button(0, 99, 1, (val) => {
			    hours = val;
			    create_label();
		    });
		    
		    var minutes_view = create_spin_button(0, 99, 1, (val) => {
			    minutes = val;
			    create_label();
		    });
		    
		    time_grid.add(hours_view);
		    time_grid.add(new Gtk.Label(":"));
		    time_grid.add(minutes_view);
		    time_grid.add(new Gtk.Label(":"));
		    time_grid.add(seconds_view);
		    
		    time_grid.show_all();
            
            seconds_view.set_value(seconds);
            hours_view.set_value(hours);
            minutes_view.set_value(minutes);
            
            popover = new Gtk.Popover (parent);
            popover.add (time_grid);
            popover.get_style_context().add_class("popover");
            popover.popup();
        }
    	
    	public int64 get_seconds() {
    		return Utils.to_seconds(hours, minutes, seconds);
    	}
    	
    	public void set_seconds(int64 seconds) {
    	    this.hours = (int) (seconds / Utils.HOUR);
    	    this.minutes = (int) ((seconds - (this.hours * Utils.HOUR)) / Utils.MINUTE);
    	    this.seconds = (int) (seconds - (this.hours * Utils.HOUR) - (this.minutes * Utils.MINUTE));
    		create_label();
    	}
    	
    	private Gtk.SpinButton create_spin_button(int from, int to, int step, owned IntType action) {
            var spin = new Gtk.SpinButton.with_range(from, to, step);
		    spin.orientation = Gtk.Orientation.VERTICAL;
		    spin.get_style_context().add_class("time_button");
		    spin.value_changed.connect (() => {
			    action(spin.get_value_as_int());
		    });
		    return spin;
        }
    	
    	private void create_label() {
    		re_presentation = Utils.to_label(hours, minutes, seconds);
    		Logger.log(@"create_label: re_p -> $re_presentation");
    		label.set_label(re_presentation);
    	}
    }
}
