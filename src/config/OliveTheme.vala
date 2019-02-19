namespace Tasks {
    public class OliveTheme : AppTheme, GLib.Object {
        public string get_bg_color() {
            return "#a5d6a7";
        }
        
        public string get_bg_top_color() {
            return "#a5d6a7";
        }
        
        public string get_bg_bottom_color() {
            return "#a5d6a7";
        }
        
        public string get_card_bg_color() {
            return "#d7ffd9";
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
            return "#ff3d00";
        }
        
        public string get_accent_light_color() {
            return "#ff7539";
        }
        
        public string get_accent_dark_color() {
            return "#c30000";
        }
        
        public string get_alpha_accent_color() {
            return "rgba(255, 61, 0, 0.12)";
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
