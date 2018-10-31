namespace Tasks {

    public class TaskDialog : Gtk.Window {
    	
    	public TaskDialog(Gtk.Window parent, Event event) {
    	    Object (
                application: parent.application,
                resizable: false
            );
            
            set_size_request (350, 100);
            resize(350, 150);
            set_hide_titlebar_when_maximized (false);
    	    
    	    this.title = event.summary;
		    this.set_decorated(false);
		    this.set_transient_for(parent);
		    this.get_style_context().add_class("material-dialog");
		    
		    Gtk.Grid grid = new Gtk.Grid ();
            grid.vexpand = true;
            grid.hexpand = false;
            grid.width_request = 350;
            grid.margin_start = 16;
            grid.margin_end = 16;
            grid.margin_top = 4;
            grid.margin_bottom = 4;
            grid.orientation = Gtk.Orientation.VERTICAL;
            
            var title_view = new Gtk.Label(event.summary);
            title_view.set_xalign(0.0f);
            title_view.get_style_context().add_class(CssData.LABEL_PRIMARY);
            grid.add(title_view);
            
            if (event.description != "") {
                var label = new Gtk.Label(event.description);
                label.set_xalign(0.0f);
                label.set_line_wrap(true);
                label.single_line_mode = false;
                label.wrap = true;
                label.wrap_mode = Pango.WrapMode.WORD;
                label.get_style_context().add_class(CssData.LABEL_SECONDARY);
                grid.add(label);
            }
            
            var vert_exp = new Gtk.Grid();
            vert_exp.hexpand = true;
            vert_exp.vexpand = true;
            grid.add(vert_exp);
            
            var hor_grid = new Gtk.Grid();
            hor_grid.hexpand = true;
            hor_grid.vexpand = false;
            hor_grid.orientation = Gtk.Orientation.HORIZONTAL;
            
            grid.add(hor_grid);
            
            var empty_view = new Gtk.Grid();
            empty_view.hexpand = true;
            empty_view.vexpand = false;
            empty_view.height_request = 25;
            hor_grid.add(empty_view);
            
            var button = new Gtk.Button.with_label (_("OK"));
		    button.hexpand = false;
		    button.clicked.connect (() => {
			    destroy();
		    });
		    button.get_style_context().add_class("dialog-button");
		    hor_grid.add(button);
            
            grid.show_all ();
		    this.add(grid);
		    this.show_all ();
    	}
    }
}
