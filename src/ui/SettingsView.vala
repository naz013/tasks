namespace Tasks {

    public class SettingsView : Gtk.EventBox {
    
        public signal void theme_selected(int theme);
        public signal void multi_changed(bool is_multi);
        
        public SettingsView() {
            var color_button_light = new Gtk.RadioButton (null);
            color_button_light.halign = Gtk.Align.CENTER;
            color_button_light.tooltip_text = _("Light");

            var color_button_light_context = color_button_light.get_style_context ();
            color_button_light_context.add_class (CssData.COLOR_RADIO);
            color_button_light_context.add_class ("color-light");
            
            var color_button_sand = new Gtk.RadioButton.from_widget (color_button_light);
            color_button_sand.halign = Gtk.Align.CENTER;
            color_button_sand.tooltip_text = _("Sand");

            var color_button_sand_context = color_button_sand.get_style_context ();
            color_button_sand_context.add_class (CssData.COLOR_RADIO);
            color_button_sand_context.add_class ("color-sand");

            var color_button_dark = new Gtk.RadioButton.from_widget (color_button_light);
            color_button_dark.halign = Gtk.Align.CENTER;
            color_button_dark.tooltip_text = _("Dark");

            var color_button_dark_context = color_button_dark.get_style_context ();
            color_button_dark_context.add_class (CssData.COLOR_RADIO);
            color_button_dark_context.add_class ("color-dark");
            
            var color_button_olive = new Gtk.RadioButton.from_widget (color_button_light);
            color_button_olive.halign = Gtk.Align.CENTER;
            color_button_olive.tooltip_text = _("Olive");

            var color_button_olive_context = color_button_olive.get_style_context ();
            color_button_olive_context.add_class (CssData.COLOR_RADIO);
            color_button_olive_context.add_class ("color-olive");
            
            var color_button_grape = new Gtk.RadioButton.from_widget (color_button_light);
            color_button_grape.halign = Gtk.Align.CENTER;
            color_button_grape.tooltip_text = _("Grape");

            var color_button_grape_context = color_button_grape.get_style_context ();
            color_button_grape_context.add_class (CssData.COLOR_RADIO);
            color_button_grape_context.add_class ("color-grape");
            
            var color_button_green_gradient = new Gtk.RadioButton.from_widget (color_button_light);
            color_button_green_gradient.halign = Gtk.Align.CENTER;
            color_button_green_gradient.tooltip_text = _("Green Gradient");
            
            var color_button_green_gradient_context = color_button_green_gradient.get_style_context ();
            color_button_green_gradient_context.add_class (CssData.COLOR_RADIO);
            color_button_green_gradient_context.add_class ("color-green-gradient");
            
            var color_button_sunset = new Gtk.RadioButton.from_widget (color_button_light);
            color_button_sunset.halign = Gtk.Align.CENTER;
            color_button_sunset.tooltip_text = _("Sunset");
            
            var color_button_sunset_context = color_button_sunset.get_style_context ();
            color_button_sunset_context.add_class (CssData.COLOR_RADIO);
            color_button_sunset_context.add_class ("color-sunset");
            
            var menu_grid = new Gtk.Grid ();
            menu_grid.margin_bottom = 3;
            menu_grid.column_spacing = 12;
            menu_grid.margin = 12;
            menu_grid.orientation = Gtk.Orientation.VERTICAL;
            menu_grid.attach (color_button_dark, 0, 0, 1, 1);
            menu_grid.attach (color_button_light, 1, 0, 1, 1);
            menu_grid.attach (color_button_sand, 2, 0, 1, 1);
            menu_grid.attach (color_button_olive, 3, 0, 1, 1);
            menu_grid.attach (color_button_grape, 4, 0, 1, 1);
            menu_grid.attach (color_button_green_gradient, 5, 0, 1, 1);
            menu_grid.attach (color_button_sunset, 6, 0, 1, 1);
            menu_grid.show_all ();
            
            switch (AppSettings.get_default().app_theme) {
                case 0:
                    color_button_dark.active = true;
                    break;
                case 1:
                    color_button_light.active = true;
                    break;
                case 2:
                    color_button_sand.active = true;
                    break;
                case 3:
                    color_button_olive.active = true;
                    break;
                case 4:
                    color_button_grape.active = true;
                    break;
                case 5:
                    color_button_green_gradient.active = true;
                    break;
                case 6:
                    color_button_sunset.active = true;
                    break;
            }
            
            theme_button_click(color_button_dark, 0);
            theme_button_click(color_button_light, 1);
            theme_button_click(color_button_sand, 2);
            theme_button_click(color_button_olive, 3);
            theme_button_click(color_button_grape, 4);
            theme_button_click(color_button_green_gradient, 5);
            theme_button_click(color_button_sunset, 6);
            
            var multi_switch = new Gtk.Switch();
		    multi_switch.vexpand = false;
		    multi_switch.active = AppSettings.get_default().is_multi;
		    multi_switch.notify["active"].connect (() => {
                multi_changed(multi_switch.active);
    		});
            multi_switch.get_style_context().add_class(CssData.MATERIAL_SWITCH);
		    
		    var multi_label = new Gtk.Button.with_label (_("Multicolumn View"));
            multi_label.clicked.connect (() => {
                multi_switch.active = !multi_switch.active;
            });
            multi_label.get_style_context().add_class(CssData.MATERIAL_BUTTON_FLAT);
            
            var box = new Gtk.Fixed();
            box.hexpand = true;
            box.vexpand = false;
            
            var box1 = new Gtk.Fixed();
            box1.hexpand = true;
            box1.vexpand = false;
            
            var multi_grid = new Gtk.Grid ();
            multi_grid.column_spacing = 8;
            multi_grid.hexpand = true;
            multi_grid.orientation = Gtk.Orientation.HORIZONTAL;
            multi_grid.add(box);
            multi_grid.add(multi_label);
            multi_grid.add(multi_switch);
            multi_grid.add(box1);
            
            var grid = new Gtk.Grid ();
            grid.margin_bottom = 3;
            grid.column_spacing = 12;
            grid.margin = 12;
            grid.orientation = Gtk.Orientation.VERTICAL;
            
            grid.add(multi_grid);
            grid.add(menu_grid);
            grid.show_all();
            
            add(grid);
        }
        
        private void theme_button_click(Gtk.RadioButton button, int theme) {
            button.clicked.connect (() => {
                theme_selected(theme);
            });
        }
    }
}
