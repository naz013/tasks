namespace Tasks {

    public class ListView : Gtk.EventBox {
        
        public signal void on_edit(Event task);
        public signal void on_delete(Event task);
        public signal void on_copy(Event task);
        public signal void on_undo(Event task);
        public signal void on_add_clicked();
        
        private Gtk.ListBox list_box;
        private Gtk.Button fab;
        private SnackBar snackbar;
        
        private bool is_max = false;
        
        public ListView(Gee.ArrayList<Event> tasks) {
            var overlay = new Gtk.Overlay();
            overlay.expand = true;
            
            Gtk.ScrolledWindow scrolled = new Gtk.ScrolledWindow (null, null);
            scrolled.expand = true;
            
            list_box = new Gtk.ListBox();
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
            
            snackbar = new SnackBar();
            snackbar.on_show.connect(() => {
                overlay.set_overlay_pass_through(vert_grid, false);
            });
            snackbar.on_hide.connect(() => {
                overlay.set_overlay_pass_through(vert_grid, true);
            });
            // hor_grid.add(snackbar);
            
            var box2 = new Gtk.Fixed();
            box2.hexpand = true;
            box2.vexpand = false;
            
            fab = new Gtk.Button.from_icon_name ("list-add-symbolic", Gtk.IconSize.SMALL_TOOLBAR);
		    fab.hexpand = false;
		    fab.set_always_show_image(true);
		    fab.set_label("Add task");
		    fab.clicked.connect (() => {
			    on_add_clicked();
		    });
		    fab.get_style_context().add_class(CssData.MATERIAL_FAB);
		    
            
            hor_grid.add(box2);
            hor_grid.add(fab);
            overlay.add_overlay(vert_grid);
            
            overlay.set_overlay_pass_through(vert_grid, true);
            
            overlay.show_all();
            add(overlay);
            
            update_fab();
        }
        
        public void set_maximazed(bool max) {
        	this.is_max = max;
        	update_fab();
        }
        
        public void refresh_list(Gee.ArrayList<Event> tasks) {
            list_box.forall ((element) => list_box.remove (element));
            for (int i = 0; i < tasks.size; i++) {
                Event task = tasks.get(i);
                list_box.add(get_row(task));
            }
        }
        
        private void update_fab() {
        	if (is_max) {
        		hide_fab();
        	} else {
        		show_fab();
        	}
        }
        
        private void show_fab() {
        	fab.set_opacity(1);
        }
        
        private void hide_fab() {
        	fab.set_opacity(0);
        }
        
        private void show_undo_snackbar(Event event) {
            var message = @"Event $(event.summary) deleted.";
            snackbar.show_snackbar_with_action(message, "UNDO", () => {
                on_undo(event);
            });
        }
        
        private Gtk.ListBoxRow get_row(Event task) {
            var row = new Gtk.ListBoxRow();
            row.hexpand = true;
            row.vexpand = false;
            row.set_selectable(false);
            
            var hor_grid = new Gtk.Grid();
            hor_grid.orientation = Gtk.Orientation.HORIZONTAL;
            hor_grid.hexpand = true;
            hor_grid.get_style_context().add_class("row_item");
            hor_grid.get_style_context().add_class(CssData.MATERIAL_CARD);
            
            var button_grid = new Gtk.Grid();
            button_grid.orientation = Gtk.Orientation.HORIZONTAL;
            
            var edit_button = new Gtk.Button.from_icon_name ("document-edit-symbolic", Gtk.IconSize.BUTTON);
            edit_button.has_tooltip = true;
            edit_button.hexpand = false;
		    edit_button.set_always_show_image(true);
            edit_button.tooltip_text = ("Edit task");
            edit_button.get_style_context().add_class("icon_button");
            edit_button.clicked.connect (() => {
                Logger.log(@"Edit row $(task.to_string())");
			    on_edit(task);
		    });
            
            var delete_button = new Gtk.Button.from_icon_name ("edit-delete-symbolic", Gtk.IconSize.BUTTON);
            delete_button.has_tooltip = true;
            delete_button.tooltip_text = ("Delete task");
            delete_button.get_style_context().add_class("icon_button");
            delete_button.clicked.connect (() => {
                Logger.log(@"Delete row $(task.to_string())");
			    on_delete(task);
			    // show_undo_snackbar(task);
		    });
		    
		    var copy_button = new Gtk.Button.from_icon_name ("edit-copy-symbolic", Gtk.IconSize.BUTTON);
            copy_button.has_tooltip = true;
            copy_button.tooltip_text = ("Copy task");
            copy_button.get_style_context().add_class("icon_button");
            copy_button.clicked.connect (() => {
                Logger.log(@"Copy row $(task.to_string())");
			    on_copy(task);
		    });
            
            button_grid.add(edit_button);
            button_grid.add(delete_button);
            button_grid.add(copy_button);
            
            var vert_grid = new Gtk.Grid();
            vert_grid.orientation = Gtk.Orientation.VERTICAL;
            vert_grid.hexpand = true;
            
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
                	string format = "%a, %e %b %y, %H:%M";
				    string date_time = new DateTime.from_unix_local(task.due_date_time).format(format);
				    
				    var date_label = new Gtk.Label(date_time);
				    date_label.set_xalign(0.0f);
				    date_label.get_style_context().add_class(CssData.LABEL_PRIMARY);
				    
				    vert_grid.add(date_label);
                }
            }
            
            hor_grid.add(vert_grid);
            hor_grid.add(button_grid);
            
            row.add(hor_grid);
            row.show_all();
            
            return row;
        }
    }
}
