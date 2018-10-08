
namespace Tasks {
    public class HomeWindow : Gtk.Window {

        private Gee.ArrayList<ListEvent> events = new Gee.ArrayList<ListEvent>();

        private Gtk.Grid grid = new Gtk.Grid ();
        private Gtk.HeaderBar header;
        private Gtk.Popover popover;
        private Gtk.Switch mode_switch;
        private Gtk.Entry summary_field;
        private Gtk.Entry description_field;
        private Gtk.Label summary_label;
        private Gtk.Label description_label;

        private bool create_open = false;
        private bool change_theme = true;
        private bool settings_visible = false;
        private int width = 500;
        private int height = 500;

        public AppTheme app_theme = new LightTheme();

        public SimpleActionGroup actions { get; construct; }
        
        private string summary_hint = "Summary";
        private string description_hint = "Description";

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
                print("\nFocus out");
                return false;
            });
        }
        
        private int get_header_height() {
            return header.get_allocated_height();
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

            print("\nCalculated dimentions: x -> ".concat(new_width.to_string()).concat(", y -> ").concat(new_height.to_string()));

            this.get_style_context().add_class("rounded");
            
            Gtk.Grid main_grid = new Gtk.Grid();
            main_grid.expand = true;
            main_grid.orientation = Gtk.Orientation.HORIZONTAL;
            main_grid.get_style_context().add_class("main_grid");
            grid.add(main_grid);

            if (events.size == 0) {
                var empty_label = new Gtk.Label ("No events, use Plus button to add one");
		        empty_label.set_use_markup (false);
                empty_label.set_line_wrap (true);
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
                Gtk.ListBox list_box = new Gtk.ListBox();
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
            }
            update_theme();
            this.show_all();
        }
        
        private void add_create_task_panel(Gtk.Grid grid) {
            Gtk.Grid vert_grid = new Gtk.Grid();
            vert_grid.height_request = 500;
            vert_grid.width_request = 250;
            vert_grid.orientation = Gtk.Orientation.VERTICAL;
            vert_grid.show_all ();
            
            //Scrollable holder
            
            Gtk.Grid scrollable_grid = new Gtk.Grid();
            scrollable_grid.expand = true;
            scrollable_grid.orientation = Gtk.Orientation.VERTICAL;
            scrollable_grid.show_all ();
            vert_grid.add(scrollable_grid);
            
            summary_label = create_hint_label(summary_hint);
		    scrollable_grid.add(summary_label);
            
            summary_field = new Gtk.Entry ();
		    summary_field.set_text(summary_hint);
		    summary_field.set_max_length(72);
		    summary_field.width_request = 218;
		    summary_field.focus_in_event.connect(() => {
		        string text = summary_field.get_text();
                if (text == summary_hint) {
                    summary_field.set_text("");
                }
                summary_label.set_opacity(1);
		        return true;
		    });
		    summary_field.focus_out_event.connect(() => {
		        string text = summary_field.get_text();
                if (text == "") {
                    summary_field.set_text(summary_hint);
                }
                summary_label.set_opacity(0);
		        return true;
		    });
		    summary_field.get_style_context().add_class("input_field");
		    scrollable_grid.add(summary_field);
		    
		    scrollable_grid.add(create_empty_space(16));
		    description_label = create_hint_label(description_hint);
		    scrollable_grid.add(description_label);
		    
		    description_field = new Gtk.Entry ();
		    description_field.set_text(description_hint);
		    description_field.set_max_length(500);
		    description_field.width_request = 218;
		    description_field.focus_in_event.connect(() => {
		        string text = description_field.get_text();
                if (text == description_hint) {
                    description_field.set_text("");
                }
                description_label.set_opacity(1);
		        return true;
		    });
		    description_field.focus_out_event.connect(() => {
		        string text = description_field.get_text();
                if (text == "") {
                    description_field.set_text(description_hint);
                }
                description_label.set_opacity(0);
		        return true;
		    });
		    description_field.get_style_context().add_class("input_field");
		    scrollable_grid.add(description_field);
		    
		    //Buttons holder
		    Gtk.Grid button_grid = new Gtk.Grid();
            button_grid.height_request = 32;
            button_grid.width_request = 218;
            button_grid.orientation = Gtk.Orientation.HORIZONTAL;
            button_grid.show_all ();
            button_grid.get_style_context().add_class("buttons_block");
            vert_grid.add(button_grid);
            
            Gtk.Button button_save = new Gtk.Button.with_label ("Save");
            button_save.height_request = 32;
            button_save.width_request = 109;
		    button_save.clicked.connect (() => {
			    print("\nSave clicked");
		    });
		    button_save.get_style_context().add_class("material_button");
		    button_grid.add (button_save);
		    
		    Gtk.Button button_cancel = new Gtk.Button.with_label ("Cancel");
		    button_cancel.height_request = 32;
            button_cancel.width_request = 109;
		    button_cancel.clicked.connect (() => {
			    add_action();
		    });
		    button_cancel.get_style_context().add_class("material_button");
		    button_grid.add (button_cancel);
		    
		    vert_grid.get_style_context().add_class("right_block");
            grid.add(vert_grid);
        }
        
        private Gtk.Label create_hint_label(string label) {
            Gtk.Label hint_label = new Gtk.Label(label);
            hint_label.set_use_markup (true);
		    hint_label.set_line_wrap (true);
		    hint_label.set_selectable (false);
		    hint_label.set_opacity(0);
		    hint_label.set_xalign(0.0f);
		    hint_label.get_style_context().add_class("hint_label");
		    return hint_label;
        }
        
        private Gtk.Widget create_empty_space(int height) {
            Gtk.Widget empty_space = new Gtk.Label("");
            description_field.height_request = height;
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
                    background: @bgColor;
                    border: 1px solid @accentColor;
                    border-radius: 5px 5px 0px 0px;
                    padding: 5px;
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
                    app_theme.get_accent_color()
                );
            } else {
                style = (N_("""
                @define-color textColorPrimary %s;
                @define-color textColorSecondary %s;
                @define-color bgColor %s;
                @define-color accentColor %s;
                
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
                    background: @bgColor;
                    border: 1px solid @accentColor;
                    border-radius: 5px 5px 0px 0px;
                    padding: 5px;
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

                .material_button {
                    color: @textColorPrimary;
                    border: 1px solid @textColorPrimary;
                }
                
                .material_button:active, .material_button:focus  {
                    border: 1px solid @accentColor;
                }
                
                .empty_label {
                    color: @textColorPrimary;
                    font-size: 15px;
                }
                
                .right_block {
                    padding: 16px;
                }
                
                .right_block, .empty_label {
                    border: 1px solid @accentColor;
                }

                .window textview.view text,
                .window headerbar {
                    background-color: @bgColor;
                    border-bottom-color: @bgColor;
                    box-shadow: none;
                }
                """)).printf(
                    app_theme.get_text_primary_color(),
                    app_theme.get_text_secondary_color(),
                    app_theme.get_bg_color(),
                    app_theme.get_accent_color()
                );
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

            var dark_mode_grid = new Gtk.Grid ();
            dark_mode_grid.column_spacing = 16;
            dark_mode_grid.attach(mode_label, 0, 0, 1, 1);
            dark_mode_grid.attach(mode_switch, 1, 0, 1, 1);

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
