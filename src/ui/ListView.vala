namespace Tasks {

    public class ListView : Gtk.EventBox {
        
        delegate void DelegateType ();
        
        public signal void on_restart(Event task);
        public signal void on_complete(Event task);
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
            	if (a.is_active) {
            		if (a.estimated_time < b.estimated_time) {
		                return -1;
		            } else if (a.estimated_time > b.estimated_time) {
		                return 1;
		            } else {
		                return 0;
		            }
            	} else {
            		if (a.estimated_time > b.estimated_time) {
		                return -1;
		            } else if (a.estimated_time < b.estimated_time) {
		                return 1;
		            } else {
		                return 0;
		            }
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
                label.set_margin_start(8);
                label.set_margin_top(8);
                return label;
            } else {
                var label = new Gtk.Label(_("Completed"));
                label.set_xalign(0.0f);
                label.get_style_context().add_class(CssData.LABEL_SECONDARY);
                label.set_margin_start(8);
                label.set_margin_top(8);
                return label;
            }
        }
        
        private Gtk.Widget get_menu_item(string title, owned DelegateType action) {
            var view = new Gtk.Button.with_label (title);
            view.clicked.connect (() => {
                hide_popover();
                action();
            });
            view.get_style_context().add_class(CssData.MENU_ITEM);
            return view;
        }
        
        private Gtk.Popover? popover;
        
        private void hide_popover() {
            if (popover != null) {
                popover.popdown();
            }
        }
        
        private void show_more(Gtk.Widget widget, Event task) {
            var menu_grid = new Gtk.Grid();
            
            int x = 0;
            if (task.is_active) {
            	menu_grid.attach(get_menu_item(_("Mark as completed"), () => {
            		on_complete(task);
            	}), 0, x, 1, 1);
            	x = x + 1;
            } else if (task.event_type == Event.TIMER) {
            	menu_grid.attach(get_menu_item(_("Start again"), () => {
            		task.is_active = true;
            		task.estimated_time = Utils.calculate_estimate_timer(task.timer_time);
            		on_restart(task);
            	}), 0, x, 1, 1);
            	x = x + 1;
            }
            
            menu_grid.attach(get_menu_item(_("Edit task"), () => {
            	on_edit(task);
            }), 0, x, 1, 1);
            x = x + 1;
            
            menu_grid.attach(get_menu_item(_("Copy task"), () => {
            	on_copy(task);
            }), 0, x, 1, 1);
            x = x + 1;
            
            menu_grid.attach(get_menu_item(_("Delete task"), () => {
            	on_delete(task);
            }), 0, x, 1, 1);
            
            menu_grid.show_all ();
            
            popover = new Gtk.Popover (widget);
            popover.add (menu_grid);
            popover.get_style_context().add_class("popover");
            popover.popup();
        }
        
        private Gtk.Widget get_more_button(Event task) {
            var button = new Gtk.Button.from_icon_name ("view-more-symbolic", Gtk.IconSize.BUTTON);
            button.has_tooltip = false;
            button.hexpand = false;
            button.set_always_show_image(true);
            button.get_style_context().add_class("icon_button");
            button.clicked.connect (() => {
                show_more(button, task);
            });
            return button;
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
		    
            button_grid.add(get_more_button(task));
            
            var vert_grid = new Gtk.Grid();
            vert_grid.orientation = Gtk.Orientation.VERTICAL;
            vert_grid.hexpand = true;
            
            var summary_label = new Gtk.Label(task.summary);
            summary_label.set_xalign(0.0f);
            summary_label.set_line_wrap(true);
            summary_label.single_line_mode = false;
            summary_label.wrap = true;
            summary_label.wrap_mode = Pango.WrapMode.WORD;
            summary_label.get_style_context().add_class(CssData.LABEL_SECONDARY);
            vert_grid.add(summary_label);
            
            if (task.description != "") {
                var desc_label = new Gtk.Label(task.description);
                desc_label.set_xalign(0.0f);
                desc_label.set_line_wrap(true);
                desc_label.single_line_mode = false;
                desc_label.wrap = true;
                desc_label.wrap_mode = Pango.WrapMode.WORD;
                desc_label.get_style_context().add_class(CssData.LABEL_SECONDARY);
                vert_grid.add(desc_label);
            }
            
            if (task.has_reminder) {
                if (task.event_type == Event.TIMER) {
                	string timer_text = _("Timer for %s").printf(Utils.to_label_from_seconds(task.timer_time));
                	
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
