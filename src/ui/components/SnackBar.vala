namespace Tasks {
	
	public class SnackBar : Gtk.EventBox {
		
		public signal void on_action();
		
		private Gtk.Label floating_error_label;
		private Gtk.Revealer floaing_error;
		
		public SnackBar() {
			floaing_error = new Gtk.Revealer();
            floaing_error.set_transition_type(Gtk.RevealerTransitionType.SLIDE_UP);
            
            floating_error_label = new Gtk.Label("");
            floating_error_label.set_xalign(0.0f);
            floating_error_label.get_style_context().add_class(CssData.LABEL_SECONDARY);
            floating_error_label.get_style_context().add_class(CssData.MATERIAL_SNACKBAR);
            
            floaing_error.add(floating_error_label);
            
            add(floaing_error);
		}
		
		public void show_snackbar(string message) {
			floating_error_label.label = message;
            floaing_error.set_reveal_child(true);
            delay_error_hide();
		}
		
		public void show_snackbar_with_action(string message, string action_label) {
			
		}
		
		private void delay_error_hide() {
            GLib.Timeout.add(2000, () => {
                floaing_error.set_reveal_child(false);
                return false;
            });
        }
	}
}
