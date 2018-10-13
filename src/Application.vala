
namespace Tasks {
    public class Application : Granite.Application {

        private HomeWindow main_window;
        private static bool create_new_window;

        public Application () {
            Object (flags: ApplicationFlags.HANDLES_COMMAND_LINE,
                    application_id: "com.github.naz013.tasks");
	    }

        construct {
            app_launcher = "com.github.naz013.tasks";
            exec_name = "com.github.naz013.tasks";

            var quit_action = new SimpleAction ("quit", null);
            set_accels_for_action ("app.quit", {"<Control>q"});
            add_action (quit_action);
            quit_action.activate.connect (() => {
    	        Logger.log("Quitting...");
                if (main_window != null) {
                    main_window.destroy();
                }
            });
            var new_action = new SimpleAction ("new", null);
            set_accels_for_action ("app.new", {"<Control>n"});
            add_action (new_action);
            new_action.activate.connect (() => {
                Logger.log("Add task...");
                if (main_window != null) {
                    main_window.add_action();
                }
            });

            var mode_action = new SimpleAction ("mode", null);
            set_accels_for_action ("app.mode", {"<Control>m"});
            add_action (mode_action);
            mode_action.activate.connect (() => {
                Logger.log("Change mode...");
                if (main_window != null) {
                    main_window.toggle_mode();
                }
            });
            
            var maximaze_action = new SimpleAction ("fullscreen", null);
            set_accels_for_action ("app.fullscreen", {"<Control>f"});
            add_action (maximaze_action);
            maximaze_action.activate.connect (() => {
                Logger.log("Change screen size...");
                if (main_window != null) {
                    main_window.max_action();
                }
            });
            
            var save_action = new SimpleAction ("save", null);
            set_accels_for_action ("app.save", {"<Control>s"});
            add_action (save_action);
            save_action.activate.connect (() => {
                Logger.log("Saving task...");
                if (main_window != null) {
                    main_window.save_action();
                }
            });
            
            var cancel_action = new SimpleAction ("cancel", null);
            set_accels_for_action ("app.cancel", {"<Control>c"});
            add_action (cancel_action);
            cancel_action.activate.connect (() => {
                Logger.log("Cancel task...");
                if (main_window != null) {
                    main_window.cancel_action();
                }
            });
        }

        protected override void activate () {
            if (main_window == null) {
                main_window = new HomeWindow(this);
            }
            main_window.present();
	    }

        public void create_task() {
            debug ("Creating a task...\n");
	    }

        protected override int command_line (ApplicationCommandLine command_line) {
            var context = new OptionContext ("File");
            context.add_main_entries (entries, Build.GETTEXT_PACKAGE);
            context.add_group (Gtk.get_option_group (true));

            string[] args = command_line.get_arguments ();
            int unclaimed_args;

            activate ();

            try {
                context.parse_strv (ref args);
                unclaimed_args = args.length - 1;
            } catch(Error e) {
                print (e.message + "\n");

                return 1;
            }

            // Create a next window if requested and it's not the app launch
            if (create_new_window) {
                create_new_window = false;
                create_task();
            }
            return 0;
        }

        const OptionEntry[] entries = {
            { "new-task", 'n', 0, OptionArg.NONE, out create_new_window, "New Task", null },
            { null }
        };

        public static int main (string[] args) {
            Intl.setlocale (LocaleCategory.ALL, "");
            Intl.textdomain (Build.GETTEXT_PACKAGE);

            var app = new Application();
            return app.run(args);
        }
    }
}
