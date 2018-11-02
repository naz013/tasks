namespace Tasks {

    public class TaskDialog : Gtk.Dialog {
    	
    	public TaskDialog(Gtk.Window parent, Event event) {
    	    Object (
                application: parent.application,
                resizable: false
            );
            
            set_size_request (250, 100);
            set_hide_titlebar_when_maximized (false);
    	    
    	    this.title = event.summary;
		    this.set_decorated(false);
		    this.set_modal(true);
		    this.set_transient_for(parent);
		    this.get_style_context().add_class("material-dialog");
		    
		    Gtk.Grid grid = new Gtk.Grid ();
            grid.vexpand = true;
            grid.margin = 0;
            grid.orientation = Gtk.Orientation.VERTICAL;
            
            var title_view = new Gtk.Label(event.summary);
            title_view.set_xalign(0.0f);
            title_view.margin_start = 16;
            title_view.margin_end = 16;
            title_view.margin_top = 8;
            title_view.get_style_context().add_class(CssData.LABEL_PRIMARY);
            grid.add(title_view);
            
            if (event.description != "") {
                var label = new Gtk.Label(event.description);
                label.hexpand = true;
                label.margin_start = 16;
                label.margin_end = 16;
                label.margin_top = 8;
                label.max_width_chars = 45;
                label.set_xalign(0.0f);
                label.set_line_wrap(true);
                label.single_line_mode = false;
                label.wrap = true;
                label.wrap_mode = Pango.WrapMode.WORD;
                label.get_style_context().add_class(CssData.LABEL_SECONDARY);
                grid.add(label);
            }
            
            if (event.event_type == Event.TIMER) {
            	string timer_text = _("Timer for %s").printf(Utils.to_label_from_seconds(event.timer_time));
            	
            	var timer_label = new Gtk.Label(timer_text);
			    timer_label.set_xalign(0.0f);
			    timer_label.margin_start = 16;
                timer_label.margin_end = 16;
                timer_label.margin_top = 8;
			    timer_label.get_style_context().add_class(CssData.LABEL_PRIMARY);
			    
			    grid.add(timer_label);
            } else if (event.event_type == Event.DATE) {
            	string format = "%a, %e %b %y, %H:%M";
			    string date_time = new DateTime.from_unix_local(event.due_date_time).format(format);
			    
			    var date_label = new Gtk.Label(date_time);
			    date_label.set_xalign(0.0f);
			    date_label.margin_start = 16;
                date_label.margin_end = 16;
                date_label.margin_top = 8;
			    date_label.get_style_context().add_class(CssData.LABEL_PRIMARY);
			    
			    grid.add(date_label);
            }
            
            var vert_exp = new Gtk.Grid();
            vert_exp.hexpand = false;
            vert_exp.vexpand = true;
            grid.add(vert_exp);
            
            var hor_grid = new Gtk.Grid();
            hor_grid.hexpand = true;
            hor_grid.vexpand = false;
            hor_grid.margin_start = 16;
            hor_grid.margin_end = 16;
            hor_grid.margin_top = 8;
            hor_grid.margin_bottom = 8;
            hor_grid.orientation = Gtk.Orientation.HORIZONTAL;
            grid.add(hor_grid);
            
            var empty_view = new Gtk.Grid();
            empty_view.hexpand = true;
            empty_view.vexpand = false;
            hor_grid.add(empty_view);
            
            var button = new Gtk.Button.with_label (_("OK"));
		    button.hexpand = false;
		    button.clicked.connect (() => {
			    destroy();
		    });
		    button.get_style_context().add_class("dialog-button");
		    hor_grid.add(button);
            
		    Gtk.Box content = get_content_area () as Gtk.Box;
		    content.forall ((element) => content.remove (element));
		    content.margin = 0;
		    content.pack_start (grid, true, true, 0);
		    
		    content.show_all ();
		    this.show_all();
    	}
    }
}
