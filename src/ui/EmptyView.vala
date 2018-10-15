namespace Tasks {

    public class EmptyView : Gtk.EventBox {
        
        public signal void on_add_clicked();
        
        public EmptyView() {
            var overlay = new Gtk.Overlay();
            overlay.expand = true;
            
            Gtk.Label empty_label = new Gtk.Label ("");
            empty_label.set_use_markup (true);
            empty_label.set_line_wrap (true);
            empty_label.set_markup ("No tasks, use \"Plus\" button to add one\n\n<b>Control+N</b> - Create task\n<b>Control+M</b> - Toggle \"Dark mode\"\n<b>Control+F</b> - Set fullscreen\n<b>Control+Q</b> - Exit");
            empty_label.set_justify(Gtk.Justification.CENTER);
            empty_label.get_style_context().add_class("empty_label");
            empty_label.expand = true;
            overlay.add(empty_label);
            
            var vert_grid = new Gtk.Grid();
            vert_grid.expand = true;
            vert_grid.orientation = Gtk.Orientation.VERTICAL;
            
            var box = new Gtk.Fixed();
            box.expand = true;
            vert_grid.add(box);
            
            var hor_grid = new Gtk.Grid();
            hor_grid.hexpand = true;
            hor_grid.vexpand = false;
            hor_grid.margin = 18;
            hor_grid.orientation = Gtk.Orientation.HORIZONTAL;
            vert_grid.add(hor_grid);
            
            var box2 = new Gtk.Fixed();
            box2.hexpand = true;
            box2.vexpand = false;
            
            var button = new Gtk.Button.from_icon_name ("list-add-symbolic", Gtk.IconSize.SMALL_TOOLBAR);
		    button.hexpand = false;
		    button.set_always_show_image(true);
		    button.set_label("Add task");
		    button.clicked.connect (() => {
			    on_add_clicked();
		    });
		    button.get_style_context().add_class(CssData.MATERIAL_FAB);
            
            hor_grid.add(box2);
            hor_grid.add(button);
            overlay.add_overlay(vert_grid);
            
            overlay.show_all();
            add(overlay);
        }
    }
}
