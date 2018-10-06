
namespace Tasks {
    public class HomeWindow : Gtk.Window {

        private Gee.ArrayList<ListEvent> events = new Gee.ArrayList<ListEvent>();

        private Gtk.Grid grid = new Gtk.Grid ();
        private Gtk.HeaderBar header;
        private Gtk.Popover popover;
        private Gtk.Switch mode_switch;

        private bool create_open = false;
        private bool change_theme = true;
        private bool settings_visible = false;
        private int width = 500;
        private int height = 500;

        public AppTheme app_theme = new LightTheme();

        public SimpleActionGroup actions { get; construct; }

        public const string ACTION_PREFIX = "win.";
        public const string ACTION_NEW = "action_new";
        public const string ACTION_MODE = "action_mode";

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
            grid.remove_row(0);
            grid.remove_column(0);

            if (create_open) {
                width = 700;
                height = 500;
            } else {
                width = 500;
                height = 500;
            }
            resize(width, height);

            int new_width, new_height;
            get_size (out new_width, out new_height);

            print("Calculated position: x -> ".concat(new_width.to_string()).concat(", y -> ").concat(new_height.to_string()));
            print("\n");

            this.get_style_context().add_class("rounded");
            update_theme();

            if (events.size == 0) {
                //Add create button
                Gtk.Fixed fixed = new Gtk.Fixed ();
                if (create_open) {
                    grid.add(fixed);

                    //Add rigth panel
                    Gtk.Grid vert_grid = new Gtk.Grid();
                    grid.attach (vert_grid, 1, 0, 1, 1);

                    vert_grid.get_style_context().add_class("create_grid");
                } else {
                    grid.add(fixed);
                }

                Gtk.Button button = new Gtk.Button.from_icon_name ("list-add-symbolic", Gtk.IconSize.BUTTON);
                button.set_label("Create task");
                button.set_property("height-request", 40);
                button.set_always_show_image(true);

                int x = (fixed.get_allocated_width() / 2) - (button.get_allocated_width() / 2);
                int y = fixed.get_allocated_height() / 2 - 20;

                print("Calculated position: x -> ".concat(x.to_string()).concat(", y -> ").concat(y.to_string()));
                print("\n");

    		    fixed.put (button, 100, 100);
                button.clicked.connect (() => {
                    add_action();
                });

                fixed.get_style_context().add_class("button_container");
                button.get_style_context().add_class("add_button");
            } else {
                //Show events
                Gtk.ListBox list_box = new Gtk.ListBox();
                if (create_open) {
                    grid.add(list_box);

                    //Add rigth panel
                    Gtk.Grid vert_grid = new Gtk.Grid();
                    grid.attach_next_to(vert_grid, list_box, Gtk.PositionType.RIGHT, 3, 1);

                    vert_grid.get_style_context().add_class("create_grid");
                } else {
                    grid.add(list_box);
                }

                list_box.get_style_context().add_class("list_container");
            }
            this.show_all();
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

                .mainwindow {
                    background-color: @bgColor;
                    box-shadow: #1a1a1a;
                }

                .create_grid, .list_container, .button_container, .main_container {
                    border: 2px solid #ff0000;
                }

                .popover {
                    background-color: @bgColor;
                    box-shadow: #1a1a1a;
                }

                .mode_label {
                    color: @textColorPrimary;
                }

                .new_button {
                    color: @textColorPrimary;
                }

                GtkTextView.view {
                    color: @textColorPrimary;
                    font-size: 11px;
                }

                GtkTextView.view:selected {
                    color: #FFFFFF;
                    background-color: #64baff;
                    font-size: 11px
                }

                GtkEntry.flat {
                    background: transparent;
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

                .new_button {
                    color: @textColorPrimary;
                }

                textview.view:selected {
                    color: @textColorPrimary;
                    font-size: 14px;
                }

                textview.view:selected {
                    color: #FFFFFF;
                    background-color: #64baff;
                    font-size: 14px
                }

                entry.flat {
                    background: transparent;
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
            var new_item = new Gtk.ModelButton ();
            new_item.text = "Create task";
            new_item.action_name = HomeWindow.ACTION_PREFIX + HomeWindow.ACTION_NEW;
            new_item.get_style_context().add_class("new_button");

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
            setting_grid.margin = 6;
            setting_grid.column_spacing = 6;
            setting_grid.row_spacing = 12;
            setting_grid.orientation = Gtk.Orientation.VERTICAL;
            setting_grid.attach (dark_mode_grid, 0, 0, 1, 1);
            setting_grid.attach (new_item, 0, 1, 1, 1);
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

            header.pack_end(app_button);
        }
    }
}
