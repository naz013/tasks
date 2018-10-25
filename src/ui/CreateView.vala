namespace Tasks {

    public class CreateView : Gtk.EventBox {
    
        delegate void DelegateType ();
        
        public signal void on_add_new(Event event);
        public signal void on_update(Event event);
        public signal void on_cancel_event(Event event);
        public signal void on_cancel();
        
        private Gtk.Entry summary_field;
        private Gtk.Entry description_field;
        
        private Gtk.Label summary_label;
        private Gtk.Label description_label;
        private Gtk.Label summary_error;
        private SnackBar snackbar;
        
        private Gtk.Calendar calendar;
        private Gtk.SpinButton hours_view;
        private Gtk.SpinButton minutes_view;
        
        private Gtk.Switch due_switch;
        private Gtk.Switch notification_switch;
        
        private Gtk.Grid mutable_grid;
        private Gtk.Grid type_grid;
        
        private TimerView timer_view;
        
        private Gtk.Button cancel_button;
        private Gtk.RadioButton timer_radio;
        private Gtk.RadioButton date_radio;
        
        private bool is_max = false;
        private string summary_hint = _("Remind me...");
        private string description_hint = _("Note");
        private string type_date_time_label = _("Date/Time");
        private string type_timer_label = _("Timer");
        private int64 type = 0;
        private Event editable_event = null;
        
        public CreateView() {
            Gtk.Grid vert_grid = new Gtk.Grid();
            vert_grid.vexpand = true;
            vert_grid.hexpand = false;
            vert_grid.width_request = 258;
            vert_grid.orientation = Gtk.Orientation.VERTICAL;
            vert_grid.show_all ();
            vert_grid.size_allocate.connect(() => {
                
            });
            
            //Scrollable holder
            
            Gtk.Overlay overlay = new Gtk.Overlay();
            overlay.expand = true;
            
            Gtk.ScrolledWindow scrolled = new Gtk.ScrolledWindow (null, null);
            
            Gtk.Grid scrollable_grid = new Gtk.Grid();
            scrollable_grid.get_style_context().add_class("scrollable");
            scrollable_grid.vexpand = true;
            vert_grid.width_request = 258;
            scrollable_grid.orientation = Gtk.Orientation.VERTICAL;
            scrollable_grid.show_all ();
            
            scrolled.add(scrollable_grid);
            overlay.add(scrolled);
            
            add_error_popup(overlay);
            vert_grid.add(overlay);
            
            summary_label = create_hint_label(summary_hint, false);
		    scrollable_grid.add(summary_label);
            
            summary_field = create_entry(summary_hint, 72,  () => {
                summary_label.set_opacity(1);
                summary_field.set_state_flags(Gtk.StateFlags.FOCUSED, true);
                summary_error.set_opacity(0);
		    }, () => {
                if (summary_field.get_text() == "") {
                    summary_label.set_opacity(0);
                }
		    });
		    summary_field.get_style_context().add_class(CssData.MATERIAL_TEXT_FIELD);
		    scrollable_grid.add(summary_field);
		    
		    summary_error = create_error_label(_("Must be not empty"), false);
		    scrollable_grid.add(create_empty_space(4));
		    scrollable_grid.add(summary_error);
		    
		    description_label = create_hint_label(description_hint, false);
		    scrollable_grid.add(description_label);
		    
		    description_field = create_entry(description_hint, 500, () => {
                description_label.set_opacity(1);
                description_field.set_state_flags(Gtk.StateFlags.FOCUSED, true);
		    }, () => {
                if (description_field.get_text() == "") {
                    description_label.set_opacity(0);
                }
		    });
		    description_field.get_style_context().add_class(CssData.MATERIAL_TEXT_FIELD);
		    scrollable_grid.add(description_field);
		    
		    due_switch = new Gtk.Switch();
		    due_switch.vexpand = false;
		    due_switch.notify["active"].connect (() => {
                toggle_reminder();
    		});
            due_switch.get_style_context().add_class(CssData.MATERIAL_SWITCH);
		    
		    var due_label = new Gtk.Button.with_label (_("Due date"));
            due_label.clicked.connect (() => {
                due_switch.active = !due_switch.active;
                // Logger.log("Due label click");
            });
            due_label.get_style_context().add_class(CssData.MATERIAL_BUTTON_FLAT);
            
            var due_grid = new Gtk.Grid ();
            due_grid.column_spacing = 8;
            due_grid.attach(due_label, 0, 0, 1, 1);
            due_grid.attach(due_switch, 1, 0, 1, 1);
            
            scrollable_grid.add(create_empty_space(16));
            scrollable_grid.add(due_grid);
            
            mutable_grid = new Gtk.Grid();
            mutable_grid.hexpand = true;
		    mutable_grid.orientation = Gtk.Orientation.VERTICAL;
		    scrollable_grid.add(mutable_grid);
		    
		    add_due_view();
		    
		    //Buttons holder
		    Gtk.Grid button_grid = new Gtk.Grid();
            button_grid.hexpand = true;
            button_grid.set_column_homogeneous(true);
            button_grid.orientation = Gtk.Orientation.HORIZONTAL;
            button_grid.show_all ();
            button_grid.get_style_context().add_class("scrollable");
            
            vert_grid.add(button_grid);
            
            var button_save = create_material_button (_("SAVE (Ctrl+S)"), () => {
			    save_task();
            });
		    button_save.get_style_context().add_class(CssData.MATERIAL_BUTTON);
		    button_grid.add (button_save);
		    
		    cancel_button = create_material_button (_("CANCEL (Ctrl+C)"), () => {
		    	if (editable_event == null) {
		    		on_cancel();
		    	} else {
		    		on_cancel_event(new Event.with_event(editable_event));
		    	}
		        editable_event = null;
		    });
		    cancel_button.get_style_context().add_class(CssData.MATERIAL_BUTTON);
		    button_grid.add (cancel_button);
		    
		    vert_grid.get_style_context().add_class("right_block");
		    add(vert_grid);
		    
		    clear_view();
        }
        
        public void set_maximized(bool max) {
        	this.is_max = max;
        }
        
        public void save_task() {
        	int64 due_date_time = 0;
	        int64 timer_value = 0;
	        int64 estimated_time = 0;
	        
            var summary = summary_field.get_text();
            var note = description_field.get_text();
            
            var has_error = false;
            var has_reminder = false;
            var show_notification = false;
            
            if (summary == "") {
                has_error = true;
                summary_field.set_state_flags(Gtk.StateFlags.INCONSISTENT, true);
                summary_error.set_opacity(1);
            }
            
            if (due_switch.active) {
                show_notification = notification_switch.active;
            
		        timer_value = 0;
		        
                if (type == Event.DATE) {
                    int hour = hours_view.get_value_as_int ();
		            int minute = minutes_view.get_value_as_int ();
		            
		            int year = calendar.year;
		            int month = calendar.month + 1;
		            int day = calendar.day;
		            
		            DateTime dt = new DateTime.local(year, month, day, hour, minute, 0);
		            
                    if (show_notification && !validate_dt(dt)) {
                    	has_error = true;
                    	show_error(_("Select date in future"));
                    } else {
                        due_date_time = dt.to_unix();
                        estimated_time = due_date_time;
                    }
                } else if (type == Event.TIMER) {
                    if (timer_view != null) {
                        timer_value = timer_view.get_seconds();
                    }
                    Logger.log(@"Selected seconds -> $timer_value");
                    if (validate_time(timer_value)) {
                    	has_error = true;
                    	show_error(_("Timer time not selected"));
                    } else {
                    	DateTime dt = new DateTime.now_local ();
                    	dt = dt.add_seconds((double) timer_value);
                    	estimated_time = dt.to_unix();
                    }
                }
                has_reminder = true;
            } else {
                has_reminder = false;
                show_notification = false;
                estimated_time = 0;
            }
            
            if (has_error) {
                return;
            }
            
            Event event;
            if (editable_event != null) {
            	event = editable_event;
            	if (editable_event.id == 0) {
            	    uint id = AppSettings.get_default().last_id;
                    AppSettings.get_default().last_id = id + 1;
                    event.id = id;
                    editable_event = null;
            	}
            	event.summary = summary;
                event.description = note;
            } else {
                uint id = AppSettings.get_default().last_id;
                AppSettings.get_default().last_id = id + 1;
            	event = new Event.with_id(id, summary, note);
            }
            event.due_date_time = due_date_time;
            event.event_type = type;
            event.is_active = true;
            event.has_reminder = has_reminder;
            event.show_notification = show_notification;
            event.timer_time = timer_value;
            event.estimated_time = estimated_time;
            
            Logger.log(@"Event saved: $(event.to_string())");
            
            if (editable_event != null) {
            	on_update(event);
            } else {
            	on_add_new(event);
            }
            
            editable_event = null;
        }
        
        private bool validate_time(int64 timer_value) {
            if (timer_value <= 0) {
                return true;
            }
            return false;
        }
        
        private bool validate_dt(DateTime date) {
            DateTime now = new DateTime.now_local ();
            int res = date.compare(now);
            Logger.log(@"validate_dt: diff -> $res");
            return res > 0;
        }
        
        public void edit_event(Event event) {
            clear_view();
            
            editable_event = event;
            
            description_field.set_text(event.description);
            summary_field.set_text(event.summary);
            
            description_label.set_opacity(0);
            summary_label.set_opacity(0);
            
            if (event.has_reminder) {
                due_switch.active = true;
                notification_switch.active = event.show_notification;
                
                if (event.event_type == Event.DATE) {
                    DateTime date_time = new DateTime.from_unix_local(event.due_date_time);
                    
                    hours_view.set_value(date_time.get_hour());
                    minutes_view.set_value(date_time.get_minute());
                    
                    calendar.year = date_time.get_year();
		            calendar.month = date_time.get_month() - 1;
		            calendar.day = date_time.get_day_of_month();
                } else {
                    timer_radio.set_active(true);
                    timer_view.set_seconds(event.timer_time);
                }
            }
        }
        
        public void clear_view() {
            description_field.set_text("");
            summary_field.set_text("");
            
            description_label.set_opacity(0);
            summary_label.set_opacity(0);
            
            due_switch.set_active (false);
            
            editable_event = null;
        }
        
        private void add_error_popup(Gtk.Overlay overlay) {
            var v_grid = new Gtk.Grid();
            v_grid.expand = true;
            v_grid.orientation = Gtk.Orientation.VERTICAL;
            
            var box = new Gtk.Fixed();
            box.expand = true;
            v_grid.add(box);
            
            snackbar = new SnackBar();
            snackbar.on_show.connect(() => {
                overlay.set_overlay_pass_through(v_grid, false);
            });
            snackbar.on_hide.connect(() => {
                overlay.set_overlay_pass_through(v_grid, true);
            });
            v_grid.add(snackbar);
            
            overlay.add_overlay(v_grid);
            overlay.set_overlay_pass_through(v_grid, true);
        }
        
        private void add_due_view() {
            mutable_grid.remove_row(0);
            mutable_grid.remove_column(0);
        
            var grid = new Gtk.Grid();
            grid.hexpand = true;
		    grid.orientation = Gtk.Orientation.VERTICAL;
		    mutable_grid.add(grid);
		    
		    if (due_switch.active) {
		        add_notification_switch(grid);
		        add_type_radios(grid);
		    }
		    mutable_grid.show_all();
        }
        
        private void add_type_radios(Gtk.Grid container) {
            Gtk.ScrolledWindow scrolled = new Gtk.ScrolledWindow (null, null);
            scrolled.hexpand = true;
            
            Gtk.Grid button_grid = new Gtk.Grid();
            button_grid.column_spacing = 8;
            button_grid.orientation = Gtk.Orientation.HORIZONTAL;
            button_grid.show_all ();
            
            date_radio = new Gtk.RadioButton.with_label(null, type_date_time_label);
            date_radio.toggled.connect(toggled);
            date_radio.get_style_context().add_class(CssData.MATERIAL_RADIO_BUTTON);
            
            timer_radio = new Gtk.RadioButton.with_label(date_radio.get_group(), type_timer_label);
            timer_radio.toggled.connect(toggled);
            timer_radio.get_style_context().add_class(CssData.MATERIAL_RADIO_BUTTON);
            
            button_grid.add(date_radio);
            button_grid.add(timer_radio);
            
            button_grid.show_all();
            scrolled.add(button_grid);
            
            type_grid = new Gtk.Grid();
            type_grid.hexpand = true;
		    type_grid.orientation = Gtk.Orientation.VERTICAL;
		    toggled(date_radio);
            
            container.add(create_empty_space(16));
            container.add(scrolled);
            container.add(type_grid);
        }
        
        private void toggled (Gtk.ToggleButton button) {
            type_grid.remove_row(0);
            type_grid.remove_column(0);
            
            var grid = new Gtk.Grid();
            grid.hexpand = true;
		    grid.orientation = Gtk.Orientation.VERTICAL;
		    type_grid.add(grid);
		    
            if (button.active) {
                // Logger.log(@"Toggled radio -> $(button.label)");
                if (button.label == type_date_time_label) {
                    type = Event.DATE;
                    add_date_type(grid);
                } else if (button.label == type_timer_label) {
                    type = Event.TIMER;
                    add_timer_type(grid);
                }
            }
            type_grid.show_all();
	    }
	    
	    private void add_timer_type(Gtk.Grid container) {
		    container.add(create_hint_label(type_timer_label, true));
		    container.add(create_empty_space(16));
		    
		    timer_view = new TimerView();
		    timer_view.get_style_context().add_class("timer_view");
		    container.add(timer_view);
		    
		    container.add(create_empty_space(16));
        }
        
        private void add_date_type(Gtk.Grid container) {
		    container.add(create_hint_label(_("Date"), true));
		    
		    calendar = new Gtk.Calendar();
		    calendar.hexpand = true;
		    container.add(calendar);
		    
		    container.add(create_empty_space(16));
		    container.add(create_hint_label(_("Time"), true));
		    
		    Gtk.Grid time_grid = new Gtk.Grid();
		    time_grid.column_spacing = 4;
		    time_grid.hexpand = true;
		    time_grid.orientation = Gtk.Orientation.HORIZONTAL;
		    
		    hours_view = create_spin_button(0, 23, 1, 44, () => {
		        int val = hours_view.get_value_as_int ();
			    if (val > 23) {
			        hours_view.set_value(23.0);
			    } else if (val < 0) {
			        hours_view.set_value(0.0);
			    }
		    });
		    
		    minutes_view = create_spin_button(0, 59, 1, 44, () => {
		        int val = minutes_view.get_value_as_int ();
			    if (val > 59) {
			        minutes_view.set_value(59.0);
			    } else if (val < 0) {
			        minutes_view.set_value(0.0);
			    }
		    });
		    
		    Gtk.Widget h_empty = new Gtk.Label("");
            h_empty.width_request = 66;
            h_empty.hexpand = true;
            
            Gtk.Label m_label = new Gtk.Label(_("m"));
            m_label.set_xalign(1.0f);
            m_label.get_style_context().add_class("time_label");
            
            Gtk.Label h_label = new Gtk.Label(_("H"));
            h_label.set_xalign(0.0f);
            h_label.get_style_context().add_class("time_label");
		    
		    time_grid.add(hours_view);
		    time_grid.add(h_label);
		    time_grid.add(h_empty);
		    time_grid.add(m_label);
		    time_grid.add(minutes_view);
		    
		    container.add(time_grid);
		    
		    DateTime current_dt = new DateTime.now_local ();
            
            hours_view.set_value(current_dt.get_hour());
            minutes_view.set_value(current_dt.get_minute());
            
            calendar.year = current_dt.get_year();
	        calendar.month = current_dt.get_month() - 1;
	        calendar.day = current_dt.get_day_of_month();
        }
        
        private void add_notification_switch(Gtk.Grid container) {
            notification_switch = new Gtk.Switch();
            notification_switch.vexpand = false;
		    notification_switch.notify["active"].connect (() => {
                toggle_notification();
    		});
            notification_switch.get_style_context().add_class(CssData.MATERIAL_SWITCH);
		    
		    var label = new Gtk.Button.with_label (_("Show notification"));
            label.clicked.connect (() => {
                notification_switch.active = !notification_switch.active;
            });
            label.get_style_context().add_class(CssData.MATERIAL_BUTTON_FLAT);
            
            var grid = new Gtk.Grid ();
            grid.column_spacing = 8;
            grid.attach(label, 0, 0, 1, 1);
            grid.attach(notification_switch, 1, 0, 1, 1);
            
            container.add(create_empty_space(16));
            container.add(grid);
        }
        
        private void show_error(string label) {
            // Logger.log(@"show_error: $label");
            if (snackbar != null) {
                snackbar.show_snackbar(label);
            }
        }
        
        private void toggle_reminder() {
            // Logger.log(@"Due is enabled -> $(due_switch.active)");
            add_due_view();
        }
        
        private void toggle_notification() {
            // Logger.log(@"Notification is enabled -> $(notification_switch.active)");
        }
        
        private Gtk.SpinButton create_spin_button(int from, int to, int step, int width, owned DelegateType action) {
            var spin = new Gtk.SpinButton.with_range(from, to, step);
		    spin.orientation = Gtk.Orientation.VERTICAL;
		    spin.get_style_context().add_class("time_button");
		    spin.value_changed.connect (() => {
			    action();
		    });
		    return spin;
        }
        
        private Gtk.Button create_material_button(string label, owned DelegateType action) {
            var button = new Gtk.Button.with_label (label);
		    button.hexpand = true;
		    button.clicked.connect (() => {
			    action();
		    });
		    return button;
        }
        
        private Gtk.Entry create_entry(string hint, int max_length, owned DelegateType on, owned DelegateType off) {
            Gtk.Entry entry = new Gtk.Entry ();
		    entry.set_max_length(max_length);
		    entry.hexpand = true;
		    entry.focus_in_event.connect(() => {
		        on();
		        return true;
		    });
		    entry.focus_out_event.connect(() => {
		        off();
		        return true;
		    });
		    entry.placeholder_text = hint;
		    return entry;
        }
        
        private Gtk.Label create_hint_label(string label, bool visible) {
            Gtk.Label hint_label = new Gtk.Label(label);
            hint_label.set_use_markup (true);
		    hint_label.set_line_wrap (true);
		    hint_label.set_selectable (false);
		    if (visible) {
		        hint_label.set_opacity(1);
		    } else {
		        hint_label.set_opacity(0);
		    }
		    hint_label.set_xalign(0.0f);
		    hint_label.get_style_context().add_class(CssData.MATERIAL_HINT_LABEL);
		    return hint_label;
        }
        
        private Gtk.Label create_error_label(string label, bool visible) {
            Gtk.Label hint_label = new Gtk.Label(label);
		    hint_label.set_line_wrap (true);
		    hint_label.set_selectable (false);
		    if (visible) {
		        hint_label.set_opacity(1);
		    } else {
		        hint_label.set_opacity(0);
		    }
		    hint_label.set_xalign(0.0f);
		    hint_label.get_style_context().add_class(CssData.MATERIAL_HINT_ERROR);
		    return hint_label;
        }
        
        private Gtk.Widget create_empty_space(int height) {
            Gtk.Widget empty_space = new Gtk.Grid();
            empty_space.expand = false;
            empty_space.height_request = height;
            return empty_space;
        }
    }
}
