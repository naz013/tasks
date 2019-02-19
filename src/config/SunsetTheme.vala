namespace Tasks {
    public class SunsetTheme : AppTheme, GLib.Object {
        public string get_bg_color() {
            return "#fffcdc";
        }
        
        public string get_bg_top_color() {
            return "#fffcdc";
        }
        
        public string get_bg_bottom_color() {
            return "#d9a7c7";
        }
        
        public string get_card_bg_color() {
            return "#ffd9fa";
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
            return "#2979ff";
        }
        
        public string get_accent_light_color() {
            return "#75a7ff";
        }
        
        public string get_accent_dark_color() {
            return "#004ecb";
        }
        
        public string get_alpha_accent_color() {
            return "rgba(41, 121, 255, 0.12)";
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
        
        public bool is_dark() {
        	return false;
        }
    }
}
