
namespace Tasks {
    public class HomeWindow : Gtk.Window {
    
        delegate void DelegateType ();

        private Gee.ArrayList<ListEvent> tasks = new Gee.ArrayList<ListEvent>();

        private Gtk.Grid grid = new Gtk.Grid ();
        private Gtk.HeaderBar header;
        private Gtk.Popover popover;
        private Gtk.Switch mode_switch;

        private bool create_open = false;
        private bool was_create_open = false;
        private bool was_maximized = false;
        private bool was_minimized = false;
        private bool change_theme = true;
        private bool settings_visible = false;
        private int old_width = 500;
        private int old_height = 500;

        public AppTheme app_theme = new LightTheme();

        public SimpleActionGroup actions { get; construct; }

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

            focus_out_event.connect (() => {
                return false;
            });
            grid.size_allocate.connect(() => {
                was_create_open = create_open;
                if (is_maximized) {
                    if (!was_maximized && !create_open) {
                        draw_views();
                    }
                    was_maximized = true;
                    was_minimized = false;
                } else if (!is_maximized) {
                    if (!was_minimized && !create_open) {
                        draw_views();
                    }
                    was_maximized = false;
                    was_minimized = true;
                }
            });
            AppSettings.get_default().changed.connect(() => {
                Logger.log("Settings changed");
            });
            
            draw_views();
        }
        
        public void add_action() {
            if (is_maximized) {
                return;
            }
            create_open = !create_open;
            draw_views();
        }
        
        public void max_action() {
            if (is_maximized) {
                unmaximize();
            } else {
                maximize();
            }
        }
        
        public void save_action() {
            
        }
        
        public void cancel_action() {
            
        }

        private void init_theme() {
            if (AppSettings.get_default().theme == 0) {
                app_theme = new DarkTheme();
            } else {
                app_theme = new LightTheme();
            }
        }

        private void draw_views() {
            int new_width, new_height;
            get_size (out new_width, out new_height);
            
            Logger.log(@"Draw screen: width -> $new_width, height -> $new_height, max -> $is_maximized");
            
            grid.remove_row(0);
            grid.remove_column(0);

            if (create_open) {
                if (!was_create_open && !is_maximized) {
                    new_width = new_width + 250;
                }
            } else if (was_create_open) {
                new_width = new_width - 250;
            } else if (is_maximized) {
                
            }
            resize(new_width, new_height);

            this.get_style_context().add_class("rounded");
            
            Gtk.Grid main_grid = new Gtk.Grid();
            main_grid.expand = true;
            main_grid.orientation = Gtk.Orientation.HORIZONTAL;
            main_grid.get_style_context().add_class("main_grid");
            grid.add(main_grid);

            if (tasks.size == 0) {
                main_grid.add(new EmptyView());
                if (create_open || is_maximized) {

                    //Add rigth panel
                    add_create_task_panel(main_grid);
                }
            } else {
                //Show events
                var list_box = new ListView(tasks);
                list_box.on_edit.connect((list_event) => {
                    Logger.log(@"Edit row $(list_event.summary)");
                });
                list_box.on_delete.connect((list_event) => {
                    Logger.log(@"Delete row $(list_event.summary)");
                });
                list_box.on_copy.connect((list_event) => {
                    Logger.log(@"Copy row $(list_event.summary)");
                });
                
                main_grid.add(list_box);
                if (create_open || is_maximized) {

                    //Add rigth panel
                    add_create_task_panel(main_grid);
                }
            }
            update_theme();
            this.show_all();
        }
        
        private void add_create_task_panel(Gtk.Grid grid) {
            CreateView create_view = new CreateView();
            create_view.on_save.connect((event) => {
                tasks.add(new ListEvent.with_event(event));
                create_open = false;
                draw_views();
            });
            create_view.on_cancel.connect(() => {
                add_action();
            });
            grid.add(create_view);
        }

        private void update_theme() {
            var css_provider = new Gtk.CssProvider();
            this.get_style_context().add_class("mainwindow");
            this.get_style_context().add_class("window");

            try {
                css_provider.load_from_data(new CssData.with_theme(app_theme).get_css_data(), -1);
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
            if (AppSettings.get_default().theme == 0) {
                AppSettings.get_default().theme = 1;
            } else {
                AppSettings.get_default().theme = 0;
            }
            
            init_theme();
            draw_views();
            if (settings_visible && mode_switch != null) {
                toggle_mode_switch();
            }
        }

        private void toggle_mode_switch() {
            change_theme = false;
            mode_switch.set_active (AppSettings.get_default().theme == 0);
            change_theme = true;
        }

        private void create_app_menu() {
            mode_switch = new Gtk.Switch ();
            mode_switch.notify["active"].connect (() => {
                if (change_theme) {
                    toggle_mode();
                }
    		});
    		mode_switch.set_active (AppSettings.get_default().theme == 0);
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
            
            var moon_icon = new Gtk.Button.from_icon_name ("weather-clear-night-symbolic", Gtk.IconSize.BUTTON);
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
