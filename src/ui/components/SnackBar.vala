namespace Tasks {
	
	public class SnackBar : Gtk.EventBox {
		
		public delegate void DelegateType ();
		
		public signal void on_show();
		public signal void on_hide();
		
		private Gtk.Revealer floaing_error;
		private Gtk.Grid container;
		
		public SnackBar() {
			floaing_error = new Gtk.Revealer();
            floaing_error.set_transition_type(Gtk.RevealerTransitionType.SLIDE_UP);
            
            container = new Gtk.Grid ();
            container.hexpand = true;
            container.get_style_context().add_class(CssData.MATERIAL_SNACKBAR);
            
            floaing_error.add(container);
            
            add(floaing_error);
		}
		
		public void show_snackbar(string message) {
			on_show();
			clear_container();
			container.attach(get_label(message), 0, 0, 1, 1);
			container.show_all();
            floaing_error.set_reveal_child(true);
            delay_error_hide();
		}
		
		public void show_snackbar_with_action(string message, string action_label, owned DelegateType action) {
			on_show();
			clear_container();
			container.attach(get_label(message), 0, 0, 1, 1);
			container.attach(get_action_button(action_label, () => {
				action();
			}), 1, 0, 1, 1);
			container.show_all();
            floaing_error.set_reveal_child(true);
            delay_error_hide();
		}
		
		private Gtk.Label get_label(string message) {
			var view = new Gtk.Label(message);
            view.set_xalign(0.0f);
            view.hexpand = true;
            view.get_style_context().add_class(CssData.LABEL_SECONDARY);
            return view;
		}
		
		private Gtk.Widget get_action_button(string label, owned DelegateType action) {
			var button = new Gtk.Button.with_label (label);
            button.clicked.connect (() => {
            	hide_snackbar();
                action();
            });
            button.get_style_context().add_class(CssData.MATERIAL_BUTTON_FLAT_COLORED);
            return button;
		}
		
		private void hide_snackbar() {
			Logger.log(@"hide_snackbar: $(floaing_error.child_revealed)");
			if (floaing_error.child_revealed) {
				floaing_error.set_reveal_child(false);
				on_hide();
			}
		}
		
		private void clear_container() {
			container.forall ((element) => container.remove (element));
		}
		
		private void delay_error_hide() {
            GLib.Timeout.add(2000, () => {
                hide_snackbar();
                return false;
            });
        }
	}
}
