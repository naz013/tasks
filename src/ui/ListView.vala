namespace Tasks {

    public class ListView : Gtk.EventBox {
        
        public signal void on_edit(Event task);
        public signal void on_delete(Event task);
        public signal void on_copy(Event task);
        
        private Gtk.ListBox list_box;
        
        public ListView(Gee.ArrayList<Event> tasks) {
            Gtk.ScrolledWindow scrolled = new Gtk.ScrolledWindow (null, null);
            scrolled.expand = true;
            
            list_box = new Gtk.ListBox();
            list_box.hexpand = true;
            list_box.get_style_context().add_class("list_container");
            scrolled.add(list_box);
            
            Logger.log(@"Show list $(tasks.size)");
            
            refresh_list(tasks);
            scrolled.show_all();
            add(scrolled);
        }
        
        public void refresh_list(Gee.ArrayList<Event> tasks) {
            list_box.forall ((element) => list_box.remove (element));
            tasks.sort(comparator);
            Event? prev_task = null;
            for (int i = 0; i < tasks.size; i++) {
                Event task = tasks.get(i);
                list_box.add(get_row(task, prev_task, i == tasks.size - 1));
                prev_task = new Event.full_copy(task);
            }
        }
        
        public int comparator (Event a, Event b) {
            if (a.is_active == b.is_active) {
                if (a.estimated_time < b.estimated_time) {
                    return -1;
                } else if (a.estimated_time > b.estimated_time) {
                    return 1;
                } else {
                    return 0;
                }
            } else if (a.is_active) {
                return -1;
            } else {
                return 1;
            }
        }
        
        private Gtk.Widget? get_header_view(Event task, Event? prev) {
            if (prev != null) {
                if (task.is_active == prev.is_active) {
                    return null;
                } else {
                    return get_header(task);
                }
            } else {
                return get_header(task);
            }
        }
        
        private Gtk.Widget get_header(Event task) {
            if (task.is_active) {
                var label = new Gtk.Label(_("Active"));
                label.set_xalign(0.0f);
                label.get_style_context().add_class(CssData.LABEL_SECONDARY);
                label.set_margin_left(8);
                label.set_margin_top(8);
                return label;
            } else {
                var label = new Gtk.Label(_("Completed"));
                label.set_xalign(0.0f);
                label.get_style_context().add_class(CssData.LABEL_SECONDARY);
                label.set_margin_left(8);
                label.set_margin_top(8);
                return label;
            }
        }
        
        private Gtk.ListBoxRow get_row(Event task, Event? prev, bool is_last) {
            var row = new Gtk.ListBoxRow();
            row.hexpand = true;
            row.vexpand = false;
            row.set_selectable(false);
            
            var grid = new Gtk.Grid();
            grid.orientation = Gtk.Orientation.VERTICAL;
            grid.hexpand = true;
            
            var header_view = get_header_view(task, prev);
            if (header_view != null) {
                grid.add(header_view);
            }
            
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
            edit_button.tooltip_text = (_("Edit task"));
            edit_button.get_style_context().add_class("icon_button");
            edit_button.clicked.connect (() => {
                Logger.log(@"Edit row $(task.to_string())");
			    on_edit(task);
		    });
            
            var delete_button = new Gtk.Button.from_icon_name ("edit-delete-symbolic", Gtk.IconSize.BUTTON);
            delete_button.has_tooltip = true;
            delete_button.tooltip_text = (_("Delete task"));
            delete_button.get_style_context().add_class("icon_button");
            delete_button.clicked.connect (() => {
                Logger.log(@"Delete row $(task.to_string())");
			    on_delete(task);
		    });
		    
		    var copy_button = new Gtk.Button.from_icon_name ("edit-copy-symbolic", Gtk.IconSize.BUTTON);
            copy_button.has_tooltip = true;
            copy_button.tooltip_text = (_("Copy task"));
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
                	string timer_text = _("Timer for: %s").printf(Utils.to_label_from_seconds(task.timer_time));
                	
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
            
            grid.add(hor_grid);
            
            if (is_last) {
                var label = new Gtk.Label("");
                label.set_xalign(0.0f);
                grid.add(label);
            }
            
            row.add(grid);
            row.show_all();
            
            return row;
        }
    }
}
