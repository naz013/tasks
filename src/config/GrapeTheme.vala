namespace Tasks {
    public class GrapeTheme : AppTheme, GLib.Object {
        public string get_bg_color() {
            return "#d1c4e9";
        }
        
        public string get_card_bg_color() {
            return "#e1d4fc";
        }

        public string get_text_primary_color() {
            return "#000000";
        }

        public string get_text_secondary_color() {
            return "#000000";
        }
        
        public string get_text_disabled_color() {
            return "rgba(0, 0, 33, 0.5)";
        }

        public string get_accent_color() {
            return "#f50057";
        }
        
        public string get_accent_light_color() {
            return "#ff5983";
        }
        
        public string get_accent_dark_color() {
            return "#bb002f";
        }
        
        public string get_alpha_accent_color() {
            return "rgba(245, 0, 87, 0.12)";
        }
        
        public string get_shadow_color() {
            return "rgba(0,0,0,0.12)";
        }
        
        public string get_shadow_out_color() {
            return "rgba(0,0,0,0.24)";
        }
        
        public string get_button_disabled_color() {
            return "rgba(0, 0, 0, 0.25)";
        }
    }
}
