namespace Tasks {

    public class SettingsView : Gtk.EventBox {
    
        public signal void theme_selected(int theme);
        
        public SettingsView() {
            
            var color_button_light = new Gtk.RadioButton (null);
            color_button_light.halign = Gtk.Align.CENTER;
            color_button_light.tooltip_text = _("Light");

            var color_button_light_context = color_button_light.get_style_context ();
            color_button_light_context.add_class (CssData.COLOR_RADIO);
            color_button_light_context.add_class ("color-light");

            var color_button_dark = new Gtk.RadioButton.from_widget (color_button_light);
            color_button_dark.halign = Gtk.Align.CENTER;
            color_button_dark.tooltip_text = _("Dark");

            var color_button_dark_context = color_button_dark.get_style_context ();
            color_button_dark_context.add_class (CssData.COLOR_RADIO);
            color_button_dark_context.add_class ("color-dark");
            
            var menu_separator = new Gtk.Separator (Gtk.Orientation.HORIZONTAL);
            menu_separator.margin_top = 12;
            
            var menu_grid = new Gtk.Grid ();
            menu_grid.margin_bottom = 3;
            menu_grid.orientation = Gtk.Orientation.VERTICAL;
            menu_grid.width_request = 200;
            menu_grid.attach (color_button_light, 0, 0, 1, 1);
            menu_grid.attach (color_button_dark, 1, 0, 1, 1);
            menu_grid.attach (menu_separator, 0, 1, 2, 1);
            menu_grid.show_all ();
            
            add(menu_grid);
            
            switch (AppSettings.get_default().app_theme) {
               case 0:
                   color_button_dark.active = true;
                   break;
               case 1:
                   color_button_light.active = true;
                   break;
            }
            
            color_button_dark.clicked.connect (() => {
                AppSettings.get_default().app_theme = 0;
                theme_selected(0);
            });

            color_button_light.clicked.connect (() => {
                AppSettings.get_default().app_theme = 1;
                theme_selected(1);
            });
        }
    }
}
