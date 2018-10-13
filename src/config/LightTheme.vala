namespace Tasks {
    public class LightTheme : AppTheme, GLib.Object {
        public string get_bg_color() {
            return "#eeeeee";
        }
        
        public string get_card_bg_color() {
            return "#ffffff";
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
            return "#0091ea";
        }
        
        public string get_accent_light_color() {
            return "#64c1ff";
        }
        
        public string get_accent_dark_color() {
            return "#0064b7";
        }
        
        public string get_alpha_accent_color() {
            return "rgba(0, 145, 234, 0.12)";
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
