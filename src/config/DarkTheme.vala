namespace Tasks {
    public class DarkTheme : AppTheme, GLib.Object {
        public string get_bg_color() {
            return "#212121";
        }
        
        public string get_card_bg_color() {
            return "#484848";
        }

        public string get_text_primary_color() {
            return "#FFFFFF";
        }

        public string get_text_secondary_color() {
            return "#FFFFFF";
        }
        
        public string get_text_disabled_color() {
            return "rgba(255, 255, 255, 0.5)";
        }

        public string get_accent_color() {
            return "#00B0FF";
        }
        
        public string get_alpha_accent_color() {
            return "rgba(0, 176, 255, 0.12)";
        }
    }
}
