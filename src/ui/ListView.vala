namespace Tasks {

    public class ListView : Gtk.EventBox {
        
        public signal void on_edit(Event task);
        public signal void on_delete(Event task);
        public signal void on_copy(Event task);
        public signal void on_add_clicked();
        
        private Gtk.Grid list_box;
        
        public ListView(Gee.ArrayList<Event> tasks) {
            var overlay = new Gtk.Overlay();
            overlay.expand = true;
            
            Gtk.ScrolledWindow scrolled = new Gtk.ScrolledWindow (null, null);
            
            list_box = new Gtk.Grid();
            list_box.orientation = Gtk.Orientation.VERTICAL;
            list_box.hexpand = true;
            list_box.get_style_context().add_class("list_container");
            scrolled.add(list_box);
            
            Logger.log(@"Show list $(tasks.size)");
            
            refresh_list(tasks);
            scrolled.show_all();
            overlay.add(scrolled);
            
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
        
        public void refresh_list(Gee.ArrayList<Event> tasks) {
            list_box.forall ((element) => list_box.remove (element));
            for (int i = 0; i < tasks.size; i++) {
                Event task = tasks.get(i);
                list_box.add(get_row(task));
            }
            list_box.show_all();
        }
        
        private Gtk.ListBoxRow get_row(Event task) {
            var row = new Gtk.ListBoxRow();
            row.hexpand = true;
            row.set_selectable(false);
            
            var hor_grid = new Gtk.Grid();
            hor_grid.orientation = Gtk.Orientation.HORIZONTAL;
            hor_grid.hexpand = true;
            hor_grid.get_style_context().add_class("row_item");
            hor_grid.get_style_context().add_class(CssData.MATERIAL_CARD);
            
            var button_grid = new Gtk.Grid();
            button_grid.orientation = Gtk.Orientation.HORIZONTAL;
            button_grid.width_request = 32;
            
            var edit_button = new Gtk.Button.from_icon_name ("document-edit-symbolic", Gtk.IconSize.BUTTON);
            edit_button.has_tooltip = true;
            edit_button.tooltip_text = ("Edit task");
            edit_button.get_style_context().add_class("icon_button");
            edit_button.clicked.connect (() => {
			    on_edit(task);
		    });
            
            var delete_button = new Gtk.Button.from_icon_name ("edit-delete-symbolic", Gtk.IconSize.BUTTON);
            delete_button.has_tooltip = true;
            delete_button.tooltip_text = ("Delete task");
            delete_button.get_style_context().add_class("icon_button");
            delete_button.clicked.connect (() => {
			    on_delete(task);
		    });
		    
		    var copy_button = new Gtk.Button.from_icon_name ("edit-copy-symbolic", Gtk.IconSize.BUTTON);
            copy_button.has_tooltip = true;
            copy_button.tooltip_text = ("Copy task");
            copy_button.get_style_context().add_class("icon_button");
            copy_button.clicked.connect (() => {
			    on_copy(task);
		    });
            
            button_grid.add(edit_button);
            button_grid.add(delete_button);
            button_grid.add(copy_button);
            button_grid.show_all();
            
            var vert_grid = new Gtk.Grid();
            vert_grid.orientation = Gtk.Orientation.VERTICAL;
            vert_grid.hexpand = true;
            vert_grid.show_all ();
            
            var summary_label = new Gtk.Label(task.summary);
            summary_label.set_xalign(0.0f);
            summary_label.get_style_context().add_class(CssData.LABEL_SECONDARY);
            vert_grid.add(summary_label);
            
            if (task.description != "") {
                var desc_label = new Gtk.Label(task.description);
                desc_label.set_xalign(0.0f);
                desc_label.get_style_context().add_class(CssData.LABEL_SECONDARY);
                vert_grid.add(desc_label);
            }
            
            if (task.has_reminder) {
                if (task.event_type == Event.TIMER) {
                	string timer_text = @"Timer for: $(Utils.to_label_from_seconds(task.timer_time))";
                	
                	var timer_label = new Gtk.Label(timer_text);
				    timer_label.set_xalign(0.0f);
				    timer_label.get_style_context().add_class(CssData.LABEL_PRIMARY);
				    
				    vert_grid.add(timer_label);
                } else if (task.event_type == Event.DATE) {
                	string date = @"$(task.year)/$(task.month)/$(task.day)";
				    string time = @"$(task.hour):$(task.minute)";
				    string date_time = @"$date $time";
				    
				    var date_label = new Gtk.Label(date_time);
				    date_label.set_xalign(0.0f);
				    date_label.get_style_context().add_class(CssData.LABEL_PRIMARY);
				    
				    vert_grid.add(date_label);
                }
            }
            
            hor_grid.add(vert_grid);
            hor_grid.add(button_grid);
            hor_grid.show_all();
            
            row.add(hor_grid);
            
            Logger.log(@"Create row $(task.to_string())");
            
            return row;
        }
    }
}
