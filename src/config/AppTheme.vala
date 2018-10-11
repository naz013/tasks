namespace Tasks {
    public interface AppTheme : GLib.Object {
        public abstract string get_bg_color();
        public abstract string get_card_bg_color();
        public abstract string get_text_primary_color();
        public abstract string get_text_secondary_color();
        public abstract string get_text_disabled_color();
        public abstract string get_accent_color();
        public abstract string get_alpha_accent_color();
    }
}
