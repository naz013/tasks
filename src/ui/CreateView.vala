namespace Tasks {

    public class CreateView : Gtk.EventBox {
    
        delegate void DelegateType ();
        
        public signal void on_save(Event event);
        public signal void on_cancel();
        
        private Gtk.Entry summary_field;
        private Gtk.Entry description_field;
        private Gtk.Label summary_label;
        private Gtk.Label description_label;
        private Gtk.Calendar calendar;
        private Gtk.SpinButton hours_view;
        private Gtk.SpinButton minutes_view;
        
        private string summary_hint = "Remind me...";
        private string description_hint = "Note";
        
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
            
            Gtk.ScrolledWindow scrolled = new Gtk.ScrolledWindow (null, null);
            
            Gtk.Grid scrollable_grid = new Gtk.Grid();
            scrollable_grid.get_style_context().add_class("scrollable");
            scrollable_grid.vexpand = true;
            vert_grid.width_request = 258;
            scrollable_grid.orientation = Gtk.Orientation.VERTICAL;
            scrollable_grid.show_all ();
            
            scrolled.add(scrollable_grid);
            vert_grid.add(scrolled);
            
            summary_label = create_hint_label(summary_hint, false);
		    scrollable_grid.add(summary_label);
            
            summary_field = create_entry(summary_hint, 72,  () => {
                if (summary_field.get_text() == summary_hint) {
                    summary_field.set_text("");
                }
                summary_label.set_opacity(1);
                summary_field.set_state_flags(Gtk.StateFlags.FOCUSED, true);
		    }, () => {
                if (summary_field.get_text() == "") {
                    summary_field.set_text(summary_hint);
                    summary_label.set_opacity(0);
                }
		    });
		    summary_field.get_style_context().add_class(CssData.MATERIAL_TEXT_FIELD);
		    scrollable_grid.add(summary_field);
		    
		    scrollable_grid.add(create_empty_space(16));
		    description_label = create_hint_label(description_hint, false);
		    scrollable_grid.add(description_label);
		    
		    description_field = create_entry(description_hint, 500, () => {
                if (description_field.get_text() == description_hint) {
                    description_field.set_text("");
                }
                description_label.set_opacity(1);
                description_field.set_state_flags(Gtk.StateFlags.FOCUSED, true);
		    }, () => {
                if (description_field.get_text() == "") {
                    description_field.set_text(description_hint);
                    description_label.set_opacity(0);
                }
		    });
		    description_field.get_style_context().add_class(CssData.MATERIAL_TEXT_FIELD);
		    scrollable_grid.add(description_field);
		    
		    scrollable_grid.add(create_empty_space(16));
		    scrollable_grid.add(create_hint_label("Date", true));
		    
		    calendar = new Gtk.Calendar();
		    scrollable_grid.add(calendar);
		    
		    scrollable_grid.add(create_empty_space(16));
		    scrollable_grid.add(create_hint_label("Time", true));
		    
		    Gtk.Grid time_grid = new Gtk.Grid();
		    time_grid.column_spacing = 4;
		    time_grid.orientation = Gtk.Orientation.HORIZONTAL;
		    
		    DateTime current_dt = new DateTime.now_local ();
		    
		    hours_view = create_spin_button(0, 23, 1, 44, () => {
		        int val = hours_view.get_value_as_int ();
			    if (val > 23) {
			        hours_view.set_value(23.0);
			    } else if (val < 0) {
			        hours_view.set_value(0.0);
			    }
		    });
		    hours_view.set_value(current_dt.get_hour());
		    
		    minutes_view = create_spin_button(0, 59, 1, 44, () => {
		        int val = minutes_view.get_value_as_int ();
			    if (val > 59) {
			        minutes_view.set_value(59.0);
			    } else if (val < 0) {
			        minutes_view.set_value(0.0);
			    }
		    });
		    minutes_view.set_value(current_dt.get_minute());
		    
		    Gtk.Widget h_empty = new Gtk.Label("");
            h_empty.width_request = 66;
            
            Gtk.Label m_label = new Gtk.Label("mm");
            m_label.width_request = 24;
            m_label.set_xalign(1.0f);
            m_label.get_style_context().add_class("time_label");
            
            Gtk.Label h_label = new Gtk.Label("HH");
            h_label.width_request = 24;
            h_label.set_xalign(0.0f);
            h_label.get_style_context().add_class("time_label");
		    
		    time_grid.add(hours_view);
		    time_grid.add(h_label);
		    time_grid.add(h_empty);
		    time_grid.add(m_label);
		    time_grid.add(minutes_view);
		    
		    scrollable_grid.add(time_grid);
		    
		    //Buttons holder
		    Gtk.Grid button_grid = new Gtk.Grid();
            button_grid.hexpand = true;
            button_grid.set_column_homogeneous(true);
            button_grid.orientation = Gtk.Orientation.HORIZONTAL;
            button_grid.show_all ();
            button_grid.get_style_context().add_class("scrollable");
            
            vert_grid.add(button_grid);
            
            var button_save = create_material_button ("SAVE", () => {
			    save_task();
            });
		    button_save.get_style_context().add_class(CssData.MATERIAL_BUTTON);
		    button_grid.add (button_save);
		    
		    var button_cancel = create_material_button ("CANCEL", () => {
		        on_cancel();
		    });
		    button_cancel.get_style_context().add_class(CssData.MATERIAL_BUTTON);
		    button_grid.add (button_cancel);
		    
		    vert_grid.get_style_context().add_class("right_block");
		    add(vert_grid);
        }
        
        private void save_task() {
            var hour = hours_view.get_value_as_int ();
            var minute = minutes_view.get_value_as_int ();
            
            var year = calendar.year;
            var month = calendar.month;
            var day = calendar.day;
            
            var summary = summary_field.get_text();
            var note = description_field.get_text();
            
            var has_error = false;
            if (summary == summary_hint) {
                has_error = true;
                summary_field.set_state_flags(Gtk.StateFlags.INCONSISTENT, true);
            }
            if (note == description_hint) {
                has_error = true;
                description_field.set_state_flags(Gtk.StateFlags.INCONSISTENT, true);
            }
            
            if (has_error) {
                return;
            }
            
            Event event = new Event.with_id(0, summary, note);
            event.year = year;
            event.month = month;
            event.day = day;
            event.hour = hour;
            event.minute = minute;
            
            Logger.log("Event added");
            on_save(event);
        }
        
        public void edit_event(Event event) {
            
        }
        
        private Gtk.SpinButton create_spin_button(int from, int to, int step, int width, owned DelegateType action) {
            var spin = new Gtk.SpinButton.with_range(from, to, step);
		    spin.orientation = Gtk.Orientation.VERTICAL;
		    spin.width_request = width;
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
		    entry.set_text(hint);
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
            Gtk.Widget empty_space = new Gtk.Label("");
            empty_space.height_request = height;
            return empty_space;
        }
    }
}
