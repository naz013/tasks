namespace Tasks {
    public interface AppTheme : GLib.Object {
    
        public abstract string get_bg_color();
        public abstract string get_bg_top_color();
        public abstract string get_bg_bottom_color();
        public abstract string get_card_bg_color();
        
        public abstract string get_shadow_color();
        public abstract string get_shadow_out_color();
        
        public abstract string get_text_primary_color();
        public abstract string get_text_secondary_color();
        public abstract string get_text_disabled_color();
        
        public abstract string get_accent_color();
        public abstract string get_accent_light_color();
        public abstract string get_accent_dark_color();
        public abstract string get_alpha_accent_color();
        
        public abstract string get_button_disabled_color();
        
        public abstract bool is_dark();
    }
}
