namespace Tasks {

	public class MainContainer : Gtk.EventBox {
        
        public signal void add_clicked();
        public signal void on_event_edit(Event event);
        public signal void on_event_delete(Event event);
        public signal void on_event_copy(Event event);
        public signal void on_event_complete(Event event);
        public signal void on_event_restart(Event event);
        public signal void undo_event(Event event, int position);
        
        private SnackBar snackbar;
        private Gtk.Button fab;
        private ListView list_box;
        private Gtk.Grid grid;
        private bool is_maximized;
        private int last_delete_position = -1;
        
        public MainContainer(Gee.ArrayList<Event> tasks) {
            var overlay = new Gtk.Overlay();
            overlay.expand = true;
            
            grid = new Gtk.Grid();
            grid.expand = true;
            
            refresh_list(tasks);
            
            overlay.add(grid);
            
            var vert_grid = new Gtk.Grid();
            vert_grid.expand = true;
            vert_grid.orientation = Gtk.Orientation.VERTICAL;
            
            var box = new Gtk.Fixed();
            box.expand = true;
            vert_grid.add(box);
            
            var hor_grid = new Gtk.Grid();
            hor_grid.hexpand = true;
            hor_grid.vexpand = false;
            hor_grid.margin = 18;
            hor_grid.orientation = Gtk.Orientation.HORIZONTAL;
            
            vert_grid.add(hor_grid);
            
            snackbar = new SnackBar();
            snackbar.on_show.connect(() => {
                overlay.set_overlay_pass_through(vert_grid, false);
            });
            snackbar.on_hide.connect(() => {
                overlay.set_overlay_pass_through(vert_grid, true);
            });
            hor_grid.add(snackbar);
            
            fab = new Gtk.Button.from_icon_name ("list-add-symbolic", Gtk.IconSize.SMALL_TOOLBAR);
	        fab.hexpand = false;
	        fab.set_always_show_image(true);
	        fab.set_label(_("Add task"));
	        fab.has_tooltip = true;
	        fab.tooltip_text = "Ctrl+N";
	        fab.clicked.connect (() => {
		        add_clicked();
	        });
	        fab.get_style_context().add_class(CssData.MATERIAL_FAB);
            
            hor_grid.add(fab);
            
            vert_grid.show_all();
            overlay.add_overlay(vert_grid);
            overlay.set_overlay_pass_through(vert_grid, true);
            
            overlay.show_all();
            add(overlay);
            
            update_fab();
        }
        
        public void set_maximized(bool is_maximized) {
            this.is_maximized = is_maximized;
            update_fab();
        }
        
        public void refresh_list(Gee.ArrayList<Event> tasks) {
            Logger.log("MainContainer: refresh_list");
            if (tasks.size == 0) {
                refresh_view(tasks);
            } else {
                if (list_box != null) {
            		list_box.refresh_list(tasks);
            	} else {
            	    refresh_view(tasks);
            	}
            }
        }
        
        private void refresh_view(Gee.ArrayList<Event> tasks) {
            grid.forall ((element) => grid.remove (element));
            
            if (tasks.size == 0) {
                grid.add(new EmptyView());
                list_box = null;
            } else {
                //Show events
                list_box = new ListView(tasks);
                list_box.on_edit.connect((event) => {
                    on_event_edit(event);
                });
                list_box.on_delete.connect((event) => {
                    last_delete_position = tasks.index_of(event);
                    on_event_delete(event);
                    // show_undo_snackbar(event);
                });
                list_box.on_copy.connect((event) => {
                    on_event_copy(event);
                });
                list_box.on_complete.connect((event) => {
                    on_event_complete(event);
                });
                list_box.on_restart.connect((event) => {
                    on_event_restart(event);
                });
                grid.add(list_box);
            }
            grid.show_all();
        }
        
        private void update_fab() {
        	if (is_maximized) {
        		hide_fab();
        	} else {
        		show_fab();
        	}
        }
        
        private void show_fab() {
        	fab.set_opacity(1);
        }
        
        private void hide_fab() {
        	fab.set_opacity(0);
        }
        
        private void show_undo_snackbar(Event event) {
            var message = _("Event %s deleted.").printf(event.summary);
            snackbar.show_snackbar_with_action(message, _("UNDO"), () => {
                undo_event(event, last_delete_position);
                last_delete_position = -1;
            });
        }
    }
}
