
namespace Tasks {
    public class HomeWindow : Gtk.Window {
    
        delegate void DelegateType ();

        private Gee.ArrayList<ListEvent> tasks = new Gee.ArrayList<ListEvent>();

        private Gtk.Grid grid = new Gtk.Grid ();
        private Gtk.HeaderBar header;
        private Gtk.Popover popover;
        private Gtk.Switch mode_switch;
        private Gtk.Entry summary_field;
        private Gtk.Entry description_field;
        private Gtk.Label summary_label;
        private Gtk.Label description_label;
        private Gtk.Calendar calendar;
        private Gtk.SpinButton hours_view;
        private Gtk.SpinButton minutes_view;

        private bool create_open = false;
        private bool change_theme = true;
        private bool settings_visible = false;
        private int width = 500;
        private int height = 500;

        public AppTheme app_theme = new LightTheme();

        public SimpleActionGroup actions { get; construct; }
        
        private string summary_hint = "Remind me...";
        private string description_hint = "Note";

        public const string ACTION_PREFIX = "win.";
        public const string ACTION_MODE = "action_mode";
        public const string ACTION_NEW = "action_new";

        public static Gee.MultiMap<string, string> action_accelerators = new Gee.HashMultiMap<string, string> ();

        private const GLib.ActionEntry[] action_entries = {
            { ACTION_MODE, toggle_mode },
            { ACTION_NEW, add_action }
        };

        public HomeWindow (Gtk.Application app) {
            Object (application: app,
                    resizable: true,
                    height_request: 500,
                    width_request: 500
            );

            init_theme();

            var actions = new SimpleActionGroup ();
            actions.add_action_entries (action_entries, this);
            insert_action_group ("win", actions);

            this.set_position(Gtk.WindowPosition.CENTER);

            header = new Gtk.HeaderBar();
            header.get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);
            header.has_subtitle = false;
            header.set_title("Tasks");
            create_app_menu ();
            header.set_show_close_button (true);

            this.set_titlebar(header);
            grid.get_style_context().add_class("main_container");
            grid.expand = true;
            this.add (grid);
            draw_views();

            focus_out_event.connect (() => {
                return false;
            });
        }

        private void init_theme() {
            if (AppSettings.get_default().is_dark_mode) {
                app_theme = new DarkTheme();
            } else {
                app_theme = new LightTheme();
            }
        }

        public void draw_views() {
            set_resizable(true);
            grid.remove_row(0);
            grid.remove_column(0);

            if (create_open) {
                width = 750;
                height = 500;
            } else {
                width = 500;
                height = 500;
            }
            resize(width, height);
            set_resizable(false);

            int new_width, new_height;
            get_size (out new_width, out new_height);

            this.get_style_context().add_class("rounded");
            
            Gtk.Grid main_grid = new Gtk.Grid();
            main_grid.expand = true;
            main_grid.orientation = Gtk.Orientation.HORIZONTAL;
            main_grid.get_style_context().add_class("main_grid");
            grid.add(main_grid);

            if (tasks.size == 0) {
                Gtk.Label empty_label = new Gtk.Label ("");
                empty_label.set_use_markup (true);
                empty_label.set_line_wrap (true);
                empty_label.set_markup ("No tasks, use \"Plus\" button to add one\n\n<b>Control+N</b> - Create task\n<b>Control+M</b> - Toggle \"Dark mode\"\n<b>Control+Q</b> - Exit");
                empty_label.set_justify(Gtk.Justification.CENTER);
                empty_label.get_style_context().add_class("empty_label");
                empty_label.height_request = 500;
                empty_label.width_request = 500;
                if (create_open) {
		            main_grid.add(empty_label);

                    //Add rigth panel
                    add_create_task_panel(main_grid);
                } else {
		            main_grid.add(empty_label);
                }
            } else {
                //Show events
                var list_box = new Gtk.ListBox();
                list_box.set_selection_mode(Gtk.SelectionMode.SINGLE);
                list_box.height_request = 500;
                list_box.width_request = 500;
                if (create_open) {
                    main_grid.add(list_box);

                    //Add rigth panel
                    add_create_task_panel(main_grid);
                } else {
                    main_grid.add(list_box);
                }

                list_box.get_style_context().add_class("list_container");
                list_box.row_selected.connect((row) => {
                    Logger.log(@"Selected row $(row.get_index())");
                });
                
                Logger.log(@"Show list $(tasks.size)");
                
                for (int i = 0; i < tasks.size; i++) {
                    ListEvent task = tasks.get(i);
                    list_box.add(get_row(task));
                }
                list_box.show_all();
            }
            update_theme();
            this.show_all();
        }
        
        private Gtk.ListBoxRow get_row(ListEvent task) {
            var row = new Gtk.ListBoxRow();
            row.width_request = 500;
            row.set_selectable(true);
            
            var vert_grid = new Gtk.Grid();
            vert_grid.width_request = 500;
            vert_grid.orientation = Gtk.Orientation.VERTICAL;
            vert_grid.show_all ();
            vert_grid.get_style_context().add_class("row_item");
            
            var summary_label = new Gtk.Label(task.summary);
            var desc_label = new Gtk.Label(task.description);
            
            string date = @"$(task.year)/$(task.month)/$(task.day)";
            string time = @"$(task.hour):$(task.minute)";
            string date_time = @"$date $time";
            var date_label = new Gtk.Label(date_time);
            
            vert_grid.add(summary_label);
            vert_grid.add(desc_label);
            vert_grid.add(date_label);
            
            row.add(vert_grid);
            
            Logger.log(@"Create row $(task.summary)");
            
            return row;
        }
        
        private void add_create_task_panel(Gtk.Grid grid) {
            Gtk.Grid vert_grid = new Gtk.Grid();
            vert_grid.height_request = 500;
            vert_grid.width_request = 250;
            vert_grid.orientation = Gtk.Orientation.VERTICAL;
            vert_grid.show_all ();
            
            //Scrollable holder
            
            Gtk.ScrolledWindow scrolled = new Gtk.ScrolledWindow (null, null);
            
            Gtk.Grid scrollable_grid = new Gtk.Grid();
            scrollable_grid.expand = true;
            scrollable_grid.orientation = Gtk.Orientation.VERTICAL;
            scrollable_grid.show_all ();
            
            scrolled.add(scrollable_grid);
            vert_grid.add(scrolled);
            
            summary_label = create_hint_label(summary_hint, false);
		    scrollable_grid.add(summary_label);
            
            summary_field = create_entry(summary_hint, 72, 218, () => {
                if (summary_field.get_text() == summary_hint) {
                    summary_field.set_text("");
                }
                summary_label.set_opacity(1);
		    }, () => {
                if (summary_field.get_text() == "") {
                    summary_field.set_text(summary_hint);
                    summary_label.set_opacity(0);
                }
		    });
		    summary_field.get_style_context().add_class("input_field");
		    scrollable_grid.add(summary_field);
		    
		    scrollable_grid.add(create_empty_space(16));
		    description_label = create_hint_label(description_hint, false);
		    scrollable_grid.add(description_label);
		    
		    description_field = create_entry(description_hint, 500, 218, () => {
                if (description_field.get_text() == description_hint) {
                    description_field.set_text("");
                }
                description_label.set_opacity(1);
		    }, () => {
                if (description_field.get_text() == "") {
                    description_field.set_text(description_hint);
                    description_label.set_opacity(0);
                }
		    });
		    description_field.get_style_context().add_class("input_field");
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
            button_grid.height_request = 32;
            button_grid.width_request = 218;
            button_grid.orientation = Gtk.Orientation.HORIZONTAL;
            button_grid.show_all ();
            button_grid.get_style_context().add_class("buttons_block");
            vert_grid.add(button_grid);
            
            var button_save = create_material_button ("Save", 109, 32, () => {
			    save_task();
            });
		    button_save.get_style_context().add_class("material_button");
		    button_grid.add (button_save);
		    
		    var button_cancel = create_material_button ("Cancel", 109, 32, () => {
		        add_action();
		    });
		    button_cancel.get_style_context().add_class("material_button");
		    button_grid.add (button_cancel);
		    
		    vert_grid.get_style_context().add_class("right_block");
            grid.add(vert_grid);
        }
        
        private void save_task() {
            var hour = hours_view.get_value_as_int ();
            var minute = minutes_view.get_value_as_int ();
            
            var year = calendar.year;
            var month = calendar.month;
            var day = calendar.day;
            
            var summary = summary_field.get_text();
            var note = description_field.get_text();
            
            ListEvent event = new ListEvent.with_id(0, summary, note);
            event.year = year;
            event.month = month;
            event.day = day;
            event.hour = hour;
            event.minute = minute;
            
            Logger.log("Event added");
            
            tasks.add(event);
            create_open = false;
            draw_views();
            // Timeout.add_seconds(10, delayed_task, 1);
        }
        
        private bool delayed_task() {
            Logger.log("Delay action...");
            return true;
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
        
        private Gtk.Button create_material_button(string label, int width, int height, owned DelegateType action) {
            var button = new Gtk.Button.with_label (label);
		    button.height_request = height;
            button.width_request = width;
		    button.clicked.connect (() => {
			    action();
		    });
		    return button;
        }
        
        private Gtk.Entry create_entry(string hint, int max_length, int width, owned DelegateType on, owned DelegateType off) {
            Gtk.Entry entry = new Gtk.Entry ();
		    entry.set_text(hint);
		    entry.set_max_length(max_length);
		    entry.width_request = width;
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
		    hint_label.get_style_context().add_class("hint_label");
		    return hint_label;
        }
        
        private Gtk.Widget create_empty_space(int height) {
            Gtk.Widget empty_space = new Gtk.Label("");
            empty_space.height_request = height;
            return empty_space;
        }

        public void add_action() {
            create_open = !create_open;
            draw_views();
        }

        private void update_theme() {
            var css_provider = new Gtk.CssProvider();
            this.get_style_context().add_class("mainwindow");
            this.get_style_context().add_class("window");

            string style = null;
            if (Gtk.get_minor_version() < 20) {
                style = (N_("""
                @define-color textColorPrimary %s;
                @define-color textColorSecondary %s;
                @define-color bgColor %s;
                @define-color accentColor %s;
                @define-color accentAlphaColor %s;
                
                .input_field {
                    font-size: 13px;
                    color: @textColorPrimary;
                    background: @bgColor;
                    border: 1px solid @textColorSecondary;
                    border-radius: 5px 5px 0px 0px;
                    padding: 5px;
                }
                
                .input_field:focus {
                    font-size: 13px;
                    color: @textColorPrimary;
                    background: @accentAlphaColor;
                    border-left: 1px solid @accentAlphaColor;
                    border-top: 1px solid @accentAlphaColor;
                    border-right: 1px solid @accentAlphaColor;
                    border-bottom: 1px solid @accentColor;
                    border-radius: 5px 5px 0px 0px;
                    padding: 5px;
                }
                
                .time_label {
                    font-size: 10px;
                    color: @textColorPrimary;
                }
                
                .hint_label {
                    font-size: 10px;
                    color: @accentColor;
                }

                .mainwindow {
                    background-color: @bgColor;
                    box-shadow: #1a1a1a;
                }

                .popover {
                    background-color: @bgColor;
                    box-shadow: #1a1a1a;
                }

                .mode_label {
                    color: @textColorPrimary;
                }

                .add_button {
                    color: @textColorPrimary;
                }

                GtkTextView.view {
                    color: @textColorPrimary;
                    font-size: 11px;
                }
                
                .empty_label {
                    color: @textColorPrimary;
                    font-size: 15px;
                }

                GtkTextView.view:selected {
                    color: #FFFFFF;
                    background-color: #64baff;
                    font-size: 11px;
                }

                .window GtkTextView,
                .window GtkHeaderBar {
                    background-color: @bgColor;
                    border-bottom-color: @bgColor;
                    box-shadow: none;
                }
                """)).printf(
                    app_theme.get_text_primary_color(),
                    app_theme.get_text_secondary_color(),
                    app_theme.get_bg_color(),
                    app_theme.get_accent_color(),
                    app_theme.get_alpha_accent_color()
                );
            } else {
                style = "".concat(add_color("textColorPrimary", app_theme.get_text_primary_color()));
                style = style.concat(add_color("textColorSecondary", app_theme.get_text_secondary_color()));
                style = style.concat(add_color("bgColor", app_theme.get_bg_color()));
                style = style.concat(add_color("accentColor", app_theme.get_accent_color()));
                style = style.concat(add_color("accentAlphaColor", app_theme.get_alpha_accent_color()));
                style = style.concat(add_color("textColorDisabled", app_theme.get_text_disabled_color()));
                style = style.concat("""
                
                .input_field {
                    font-size: 13px;
                    color: @textColorPrimary;
                    background: @accentAlphaColor;
                    border: 1px solid @accentAlphaColor;
                    border-radius: 5px 5px 0px 0px;
                    padding: 5px;
                }
                
                .input_field:focus {
                    font-size: 13px;
                    color: @textColorPrimary;
                    background: @accentAlphaColor;
                    border-left: 1px solid @accentAlphaColor;
                    border-top: 1px solid @accentAlphaColor;
                    border-right: 1px solid @accentAlphaColor;
                    border-bottom: 1px solid @accentColor;
                    border-radius: 5px 5px 0px 0px;
                    padding: 5px;
                }
                
                calendar:selected {
                    color: #fff;
                    background: @accentColor;
                }

                calendar {
                    color: @textColorPrimary;
                    background: transparent;
                }
                
                calendar.button {
                    color: @textColorPrimary;
                    border: 1px solid transparent;
                    box-shadow: none;
                    padding: 4px;
                    background: transparent;
                    border-radius: 5px;
                }

                calendar.button:disabled {
                    color: @textColorDisabled;
                    border: 1px solid transparent;
                    box-shadow: none;
                    padding: 4px;
                    background: transparent;
                    border-radius: 5px;
                }

                calendar.button:hover {
                    color: @textColorPrimary;
                    background: @accentAlphaColor;
                    border: 1px solid @accentAlphaColor;
                    border-radius: 5px;
                    padding: 4px;
                    box-shadow: none;
                }
                
                calendar.button:hover:active {
                    color: @textColorPrimary;
                    background: @accentAlphaColor;
                    border: 1px solid @accentAlphaColor;
                    border-radius: 5px;
                    padding: 4px;
                    box-shadow: none;
                }
                
                calendar.button:active {
                    color: @textColorPrimary;
                    border: 1px solid transparent;
                    box-shadow: none;
                    padding: 4px;
                    background: transparent;
                    border-radius: 5px;
                }
                
                spinbutton.vertical {
                    border: 0px;
                    background: transparent;
                    box-shadow: none;
                }
                
                spinbutton entry {
                    font-size: 13px;
                    color: @textColorPrimary;
                    background: transparent;
                    border: 0px;
                    box-shadow: none;
                    border-radius: 0px;
                    padding: 5px;
                }

                spinbutton button {
                    color: @textColorPrimary;
                    border: 1px solid transparent;
                    box-shadow: none;
                    padding: 4px;
                    background: transparent;
                    border-radius: 5px;
                }

                spinbutton button:disabled {
                    color: @textColorDisabled;
                    border: 1px solid transparent;
                    box-shadow: none;
                    padding: 4px;
                    background: transparent;
                    border-radius: 5px;
                }

                spinbutton button:hover {
                    color: @textColorPrimary;
                    background: @accentAlphaColor;
                    border: 1px solid @accentAlphaColor;
                    border-radius: 5px;
                    padding: 4px;
                    box-shadow: none;
                }
                
                spinbutton button:hover:active {
                    color: @textColorPrimary;
                    background: @accentAlphaColor;
                    border: 1px solid @accentAlphaColor;
                    border-radius: 5px;
                    padding: 4px;
                    box-shadow: none;
                }
                
                spinbutton button:active {
                    color: @textColorPrimary;
                    border: 1px solid transparent;
                    box-shadow: none;
                    padding: 4px;
                    background: transparent;
                    border-radius: 5px;
                }
                
                .time_label {
                    font-size: 10px;
                    color: @textColorPrimary;
                }
                
                .time_button {
                    font-size: 13px;
                    color: @textColorPrimary;
                    background: transparent;
                    border: 0px;
                    border-radius: 0px;
                    box-shadow: none;
                }
                
                .hint_label {
                    font-size: 10px;
                    color: @accentColor;
                    padding-left: 5px;
                }

                .mainwindow {
                    background-color: @bgColor;
                    box-shadow: #1a1a1a;
                }

                .popover {
                    background-color: @bgColor;
                    box-shadow: #1a1a1a;
                }

                .mode_label {
                    color: @textColorPrimary;
                }

                .material_button {
                    border: 1px solid transparent;
                    color: @textColorPrimary;
                    box-shadow: none;
                    background: transparent;
                    border-radius: 5px;
                }
                
                .material_button:hover, .material_button:hover:active  {
                    background: @accentAlphaColor;
                    border: 1px solid @accentAlphaColor;
                    border-radius: 5px;
                    color: @textColorPrimary;
                    box-shadow: none;
                }
                
                .material_button:disabled {
                    border: 1px solid transparent;
                    color: @textColorDisabled;
                    box-shadow: none;
                    background: transparent;
                    border-radius: 5px;
                }
                
                .moon_icon {
                    border: 0px;
                    color: @textColorPrimary;
                    box-shadow: none;
                    background: transparent;
                }
                
                .empty_label {
                    color: @textColorPrimary;
                    font-size: 15px;
                }
                
                .list_container {
                    background: transparent;
                    padding: 16px;
                }
                
                .right_block {
                    padding: 16px;
                }
                
                .empty_label .row_item .list_container {
                    border: 1px solid @accentColor;
                }

                .window textview.view text,
                .window headerbar {
                    background-color: @bgColor;
                    border-bottom-color: @bgColor;
                    box-shadow: none;
                }
                """);
            }

            try {
                css_provider.load_from_data(style, -1);
            } catch (GLib.Error e) {
                warning ("Failed to parse css style : %s", e.message);
            }

            Gtk.StyleContext.add_provider_for_screen (
                Gdk.Screen.get_default (),
                css_provider,
                Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
            );
        }
        
        private string add_color(string name, string color) {
            return "@define-color ".concat(name).concat(" ").concat(color).concat(";\n");
        }

        public void toggle_mode() {
            AppSettings.get_default().is_dark_mode = !AppSettings.get_default().is_dark_mode;
            init_theme();
            draw_views();
            if (settings_visible && mode_switch != null) {
                toggle_mode_switch();
            }
        }

        private void toggle_mode_switch() {
            change_theme = false;
            mode_switch.set_active (AppSettings.get_default().is_dark_mode);
            change_theme = true;
        }

        private void create_app_menu() {
            mode_switch = new Gtk.Switch ();
            mode_switch.notify["active"].connect (() => {
                if (change_theme) {
                    toggle_mode();
                }
    		});
    		mode_switch.set_active (AppSettings.get_default().is_dark_mode);
            mode_switch.set_property("height-request", 20);
            mode_switch.get_style_context().add_class("mode_switch");

            var mode_label = new Gtk.Label ("Dark mode");
		    mode_label.set_use_markup (false);
            mode_label.set_line_wrap (true);
            mode_label.set_property("height-request", 20);
            mode_label.touch_event.connect (() => {
                toggle_mode();
                return false;
            });
            mode_label.get_style_context().add_class("mode_label");
            
            var moon_icon = new Gtk.MenuButton();
            moon_icon.image = new Gtk.Image.from_icon_name ("weather-clear-night-symbolic", Gtk.IconSize.SMALL_TOOLBAR);
            moon_icon.get_style_context().add_class("moon_icon");

            var dark_mode_grid = new Gtk.Grid ();
            dark_mode_grid.column_spacing = 4;
            dark_mode_grid.attach(moon_icon, 0, 0, 1, 1);
            dark_mode_grid.attach(mode_label, 1, 0, 1, 1);
            dark_mode_grid.attach(mode_switch, 2, 0, 1, 1);

            var setting_grid = new Gtk.Grid ();
            setting_grid.margin = 12;
            setting_grid.column_spacing = 6;
            setting_grid.row_spacing = 12;
            setting_grid.orientation = Gtk.Orientation.VERTICAL;
            setting_grid.add(dark_mode_grid);
            setting_grid.show_all ();

            popover = new Gtk.Popover (null);
            popover.add (setting_grid);
            popover.closed.connect(() => {
                settings_visible = false;
            });
            popover.show.connect(() => {
                toggle_mode_switch();
                settings_visible = true;
            });
            popover.get_style_context().add_class("popover");

            var app_button = new Gtk.MenuButton();
            app_button.has_tooltip = true;
            app_button.tooltip_text = (_("Settings"));
            app_button.image = new Gtk.Image.from_icon_name ("open-menu-symbolic", Gtk.IconSize.SMALL_TOOLBAR);
            app_button.popover = popover;
            
            var add_button = new Gtk.MenuButton();
            add_button.has_tooltip = true;
            add_button.tooltip_text = ("Create task");
            add_button.image = new Gtk.Image.from_icon_name ("list-add-symbolic", Gtk.IconSize.SMALL_TOOLBAR);
            add_button.action_name = HomeWindow.ACTION_PREFIX + HomeWindow.ACTION_NEW;
            add_button.get_style_context().add_class("new_button");

            header.pack_end(app_button);
            header.pack_end(add_button);
        }
    }
}
