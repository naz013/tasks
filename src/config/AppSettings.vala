
namespace Tasks {
    public class AppSettings : Granite.Services.Settings {
        private static AppSettings? instance;
        public int window_x { get; set; }
        public int window_y { get; set; }
        public int window_width { get; set; }
        public int window_height { get; set; }
        public int app_theme { get; set; }
        public int64 last_id { get; set; }
        public bool is_maximized { get; set; }
        public bool is_fullscreen { get; set; }

        public static unowned AppSettings get_default () {
            if (instance == null) {
                instance = new AppSettings ();
            }
            return instance;
        }

        private AppSettings () {
            base ("com.github.naz013.tasks");
        }
        
        public string to_string() {
            return @"AppSettings: x -> $window_x, y -> $window_y, theme -> $app_theme, max -> $is_maximized";
        }
    }
}
