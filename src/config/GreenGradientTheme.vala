namespace Tasks {
    public class GreenGradientTheme : AppTheme, GLib.Object {
        public string get_bg_color() {
            return "#0cebeb";
        }
        
        public string get_bg_top_color() {
            return "#0cebeb";
        }
        
        public string get_bg_bottom_color() {
            return "#29ffc6";
        }
        
        public string get_card_bg_color() {
            return "#6effff";
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
            return "#ff1744";
        }
        
        public string get_accent_light_color() {
            return "#ff616f";
        }
        
        public string get_accent_dark_color() {
            return "#c4001d";
        }
        
        public string get_alpha_accent_color() {
            return "rgba(255, 23, 68, 0.12)";
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
