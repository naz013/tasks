namespace Tasks {

    public class NotificationsView : Gtk.EventBox {
    	
    	private Gtk.Grid grid;
        
        public NotificationsView(Gee.ArrayList<Tasks.Notification> notifications) {
            grid = new Gtk.Grid ();
            grid.column_spacing = 8;
            grid.margin = 12;
            grid.orientation = Gtk.Orientation.VERTICAL;
            
            Logger.log(@"Show notifications list $(notifications.size)");
            
            refresh_list(notifications);
            grid.show_all();
            add(grid);
        }
        
        private void refresh_list(Gee.ArrayList<Tasks.Notification> notifications) {
            grid.forall ((element) => grid.remove (element));
            notifications.sort(comparator);
            for (int i = 0; i < notifications.size; i++) {
                Tasks.Notification notification = notifications.get(i);
                grid.attach(get_row(notification), 0, i, 1, 1);
            }
        }
        
        private int comparator (Tasks.Notification a, Tasks.Notification b) {
            if (a.time < b.time) {
                return -1;
            } else if (a.time > b.time) {
                return 1;
            } else {
                return 0;
            }
        }
        
        private Gtk.ListBoxRow get_row(Tasks.Notification notification) {
            var row = new Gtk.ListBoxRow();
            row.hexpand = true;
            row.vexpand = false;
            row.set_selectable(false);
            
            var grid = new Gtk.Grid();
            grid.orientation = Gtk.Orientation.VERTICAL;
            grid.hexpand = true;
            
            string format = "%a, %e %b %y, %H:%M";
		    string date_time = new DateTime.from_unix_local(notification.time).format(format);
            
            var date_label = new Gtk.Label(date_time);
            date_label.set_xalign(0.0f);
            date_label.get_style_context().add_class(CssData.LABEL_SECONDARY);
            grid.add(date_label);
            
            var summary_label = new Gtk.Label(notification.summary);
            summary_label.set_xalign(0.0f);
            summary_label.get_style_context().add_class(CssData.LABEL_SECONDARY);
            grid.add(summary_label);
            
            row.add(grid);
            row.show_all();
            
            return row;
        }
    }
}
