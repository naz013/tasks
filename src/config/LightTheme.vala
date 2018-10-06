namespace Tasks {
    public class LightTheme : AppTheme, GLib.Object {
        public string get_bg_color() {
            return "#EEEEEE";
        }

        public string get_text_primary_color() {
            return "#212121";
        }

        public string get_text_secondary_color() {
            return "#9E9E9E";
        }

        public string get_accent_color() {
            return "#673AB7";
        }
    }
}
