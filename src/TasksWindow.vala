namespace Tasks {
    public class TasksWindow : Gtk.Window {
        
        delegate void DelegateType ();

        private Gee.ArrayList<Event> tasks = new Gee.ArrayList<Event>();

        private Gtk.Grid grid = new Gtk.Grid ();
        private Gtk.HeaderBar header;
        private Gtk.Popover popover;
        private CreateView create_view;
        private MainContainer main_view;
        private Gtk.Popover? popover_notifications;

        private bool is_new = true;
        private bool create_open = false;
        private bool was_create_open = false;
        private bool was_maximized = false;
        private bool was_minimized = false;
        private bool was_resized = false;
        private bool settings_visible = false;
        private int64 old_width = 500;
        private int64 old_height = 500;

        private AppTheme app_theme = new LightTheme();
        private EventManager event_manager = new EventManager();
        private TasksController tasks_controller = new TasksController();

        public SimpleActionGroup actions { get; construct; }

        public const string ACTION_PREFIX = "win.";
        public const string ACTION_MODE = "action_mode";
        public const string ACTION_NEW = "action_new";

        public static Gee.MultiMap<string, string> action_accelerators = new Gee.HashMultiMap<string, string> ();

        private const GLib.ActionEntry[] action_entries = {
            { ACTION_MODE, toggle_mode },
            { ACTION_NEW, add_key_action }
        };

        public TasksWindow (Gtk.Application app) {
            Logger.log(AppSettings.get_default().to_string());
            Object (
                application: app
            );
            
            weak Gtk.IconTheme default_theme = Gtk.IconTheme.get_default ();
            default_theme.add_resource_path ("/com/github/naz013/tasks");
            
            if (AppSettings.get_default().is_maximized && !is_maximized) {
                maximize ();
            } else {
                default_width = AppSettings.get_default().window_width;
                default_height = AppSettings.get_default().window_height;
                move(AppSettings.get_default().window_x, AppSettings.get_default().window_y);
            }
            
            set_size_request (500, 500);
            set_hide_titlebar_when_maximized (false);
            
            int theme = AppSettings.get_default().app_theme;
            // Logger.log(@"Theme value: $theme");

            init_theme(theme);

            var actions = new SimpleActionGroup ();
            actions.add_action_entries (action_entries, this);
            insert_action_group ("win", actions);

            header = new Gtk.HeaderBar();
            header.get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);
            header.has_subtitle = false;
            header.set_title(_("Tasks"));
            create_app_menu ();
            header.set_show_close_button (true);

            this.set_titlebar(header);
            
            grid.get_style_context().add_class("main_container");
            grid.expand = true;
            grid.orientation = Gtk.Orientation.HORIZONTAL;
            grid.get_style_context().add_class("main_grid");
            
            this.add (grid);

            focus_out_event.connect (() => {
                return false;
            });
            grid.size_allocate.connect((allocation) => {
                was_create_open = create_open;
                if (is_maximized) {
                    if (!was_maximized && !create_open && !is_new) {
                        // Logger.log("From allocate 1");
                        draw_views();
                    } else {
                        is_new = false;
                    }
                    was_maximized = true;
                    was_minimized = false;
                } else if (!is_maximized) {
                    if (!was_minimized && !create_open && !is_new) {
                        // Logger.log("From allocate 2");
                        draw_views();
                    } else {
                        is_new = false;
                    }
                    was_maximized = false;
                    was_minimized = true;
                }
                if (main_view != null) {
                    main_view.set_maximized(is_maximized);
                }
                if (create_view != null) {
                    create_view.set_maximized(is_maximized);
                }
            });
            delete_event.connect(() => {
                int new_width, new_height;
                get_size (out new_width, out new_height);
                Logger.log(@"on_allocate: w -> $(new_width), h -> $(new_height)");
                AppSettings.get_default().window_width = new_width;
                AppSettings.get_default().window_height = new_height;
                AppSettings.get_default().is_maximized = is_maximized;
                
                int x, y;
                get_position (out x, out y);
                Logger.log(@"on_allocate: x -> $(x), y -> $(y)");
                AppSettings.get_default().window_x = x;
                AppSettings.get_default().window_y = y;
                return false;
            });
            
            tasks = event_manager.load_from_file();
            
            tasks_controller.find_event.connect((id) => {
                return find_event(id);
            });
            tasks_controller.show_notification.connect((event) => {
                Logger.log(@"show_notification: $(event.to_string())");
                
                show_notification(event);
            });
            tasks_controller.init_tasks(tasks);
            
            // Logger.log("From main");
            draw_views();
        }
        
        public void set_create_open(bool create_open) {
            this.create_open = create_open;
            draw_views();
        }
        
        public void add_key_action() {
            add_action();
        }
        
        public bool add_action() {
            if (is_maximized) {
                return false;
            }
            create_open = !create_open;
            draw_views();
            return true;
        }
        
        public void max_action() {
            if (is_maximized) {
                unmaximize();
            } else {
                maximize();
            }
        }
        
        public void save_action() {
            if (create_view != null) {
                create_view.save_task();
            }
        }
        
        public void cancel_action() {
            if (create_view != null) {
                if (is_maximized) {
                    create_view.clear_view();
                } else {
                    add_action();
                }
            } else {
                add_action();
            }
        }
        
        private bool screen_present() {
            return false;
        }
        
        private void show_notification(Event event) {
            update_event(event);
            event_manager.save_events(tasks);
            
            if (!screen_present()) {
                DateTime dt = new DateTime.now_local ();
                event_manager.save_notification(new Tasks.Notification(event.id, event.summary, dt.to_unix()));
            }
            
            if (event.show_notification) {
                ((Application) application).show_notification(event.summary, event.description, "alarm-symbolic");
            }
            
            if (main_view != null) {
                main_view.refresh_list(tasks);
            } else {
                draw_views();
            }
        }
        
        private Event find_event(uint id) {
            Event event = null;
            for (int i = 0; i < tasks.size; i++) {
                if (tasks.get(i).id == id) {
                    event = tasks.get(i);
                    break;
                }
            }
            return event;
        }

        private void init_theme(int theme) {
            app_theme = new LightTheme();
            switch (theme) {
                case 0:
                    app_theme = new DarkTheme();
                    break;
                case 1:
                    app_theme = new LightTheme();
                    break; 
                case 2:
                    app_theme = new SandTheme();
                    break;
                case 3:
                    app_theme = new OliveTheme();
                    break; 
                case 4:
                    app_theme = new GrapeTheme();
                    break; 
            }
            var gtk_settings = Gtk.Settings.get_default ();
            gtk_settings.gtk_application_prefer_dark_theme = app_theme.is_dark();
        }

        private void draw_views() {
            create_view = null;
            
            int new_width, new_height;
            get_size (out new_width, out new_height);
            
            // Logger.log(@"Draw screen: width -> $new_width, height -> $new_height, max -> $is_maximized");
            
            grid.forall ((element) => grid.remove (element));

            if (create_open) {
                if (!was_create_open && !is_maximized && new_width < 500) {
                    new_width = new_width + 250;
                    was_resized = true;
                }
            } else if (was_create_open && was_resized) {
                new_width = new_width - 250;
                was_resized = false;
            } else if (is_maximized) {
                was_resized = false;
            }
            resize(new_width, new_height);

            this.get_style_context().add_class("rounded");
            
            // Logger.log(@"draw_views: main_view -> $(main_view != null)");
            
            if (main_view == null) {
                main_view = new MainContainer(tasks);
                main_view.add_clicked.connect(() => {
                    add_action();
                });
                main_view.on_event_edit.connect((event) => {
                    Logger.log(@"Edit row $(event.to_string())");
                    add_action();
                    if (create_view != null) {
                        tasks_controller.stop_task(event);
                        create_view.edit_event(event);
                    }
                });
                main_view.on_event_delete.connect((event) => {
                    Logger.log(@"Delete row $(event.to_string())");
                    tasks.remove(event);
                    tasks_controller.stop_task(event);
                    event_manager.save_events(tasks);
                    if (main_view != null) {
                        main_view.refresh_list(tasks);
                    } else {
                        draw_views();
                    }
                });
                main_view.on_event_copy.connect((event) => {
                    Logger.log(@"Copy row $(event.to_string())");
                    add_action();
                    if (create_view != null) {
                        var editable = new Event.with_event(event);
                        editable.summary = event.summary + " - copy";
                        create_view.edit_event(editable);
                    }
                });
                main_view.on_event_complete.connect((event) => {
                    event.is_active = false;
                    update_event(event);
                    tasks_controller.stop_task(event);
                    event_manager.save_events(tasks);
                    if (main_view != null) {
                        main_view.refresh_list(tasks);
                    } else {
                        draw_views();
                    }
                });
                main_view.on_event_restart.connect((event) => {
                    update_event(event);
                    tasks_controller.start_task(event);
                    event_manager.save_events(tasks);
                    if (main_view != null) {
                        main_view.refresh_list(tasks);
                    } else {
                        draw_views();
                    }
                });
                main_view.undo_event.connect((event, position) => {
                    Logger.log(@"Undo row $(event.to_string()), position -> $position");
                    if (position >= 0) {
                        tasks.insert(position, event);
                        tasks_controller.start_task(event);
                        event_manager.save_events(tasks);
                        if (main_view != null) {
                            main_view.refresh_list(tasks);
                        } else {
                            draw_views();
                        }
                    }
                });
            }
            
            main_view.set_maximized(is_maximized);
            grid.add(main_view);
            
            if (create_open || is_maximized) {
                //Add rigth panel
                add_create_task_panel(grid);
            } else {
                create_view = null;
            }
            update_theme();
            this.show_all();
        }
        
        private void add_create_task_panel(Gtk.Grid grid) {
            create_view = new CreateView();
            create_view.on_add_new.connect((event) => {
                Logger.log(@"Event added: $(event.to_string())");
                tasks.add(event);
                tasks_controller.start_task(event);
                event_manager.save_events(tasks);
                add_action();
                if (main_view != null) {
                    main_view.refresh_list(tasks);
                } else {
                    draw_views();
                }
            });
            create_view.on_update.connect((event) => {
                Logger.log(@"Event updated: $(event.to_string())");
                update_event(event);
                tasks_controller.start_task(event);
                event_manager.save_events(tasks);
                add_action();
                if (main_view != null) {
                    main_view.refresh_list(tasks);
                } else {
                    draw_views();
                }
            });
            create_view.on_cancel_event.connect((event) => {
                tasks_controller.start_task(event);
                cancel_action();
            });
            create_view.on_cancel.connect(() => {
                cancel_action();
            });
            create_view.set_maximized(is_maximized);
            grid.add(create_view);
        }
        
        private void update_event(Event event) {
            for (int i = 0; i < tasks.size; i++) {
                if (tasks.get(i).id == event.id) {
                    tasks.set(i, event);
                    break;
                }
            }
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
            if (AppSettings.get_default().app_theme == 0) {
                AppSettings.get_default().app_theme = 1;
                init_theme(1);
            } else {
                AppSettings.get_default().app_theme = 0;
                init_theme(0);
            }
            
            update_theme();
        }
        
        private void show_notifications(Gtk.Button parent) {
            var notifications = event_manager.load_notifications();
            
            if (notifications.size == 0) {
                return;
            }
            
            event_manager.save_notifications(new Gee.ArrayList<Tasks.Notification>());
            
            NotificationsView notifications_view = new NotificationsView(notifications);
            notifications_view.show_all();

            popover_notifications = new Gtk.Popover (parent);
            popover_notifications.add (notifications_view);
            popover_notifications.get_style_context().add_class("popover");
            popover_notifications.popup();
        }

        private void create_app_menu() {
            var missed_button = new Gtk.Button.from_icon_name ("task-past-due-symbolic", Gtk.IconSize.BUTTON);
            missed_button.has_tooltip = true;
            missed_button.tooltip_text = _("Missed notifications");
            missed_button.hexpand = false;
            missed_button.set_always_show_image(true);
            missed_button.get_style_context().add_class("icon_button");
            missed_button.clicked.connect (() => {
                show_notifications(missed_button);
            });
            
            header.pack_end(missed_button);
            
            SettingsView settings_view = new SettingsView();
            settings_view.theme_selected.connect((theme) => {
                AppSettings.get_default().app_theme = theme;
                init_theme(theme);
                update_theme();
            });
            settings_view.show_all();

            popover = new Gtk.Popover (null);
            popover.add (settings_view);
            popover.closed.connect(() => {
                settings_visible = false;
            });
            popover.show.connect(() => {
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