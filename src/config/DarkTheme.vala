namespace Tasks {
    public class DarkTheme : AppTheme, GLib.Object {
        public string get_bg_color() {
            return "#212121";
        }

        public string get_text_primary_color() {
            return "#FFFFFF";
        }

        public string get_text_secondary_color() {
            return "#FFFFFF";
        }

        public string get_accent_color() {
            return "#00B0FF";
        }
    }
}
