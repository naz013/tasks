
namespace Tasks {
    public class AppSettings : Granite.Services.Settings {
        private static AppSettings? instance;
        public int window_x { get; set; }
        public int window_y { get; set; }
        public int app_theme { get; set; }
        public int last_id { get; set; }

        public static unowned AppSettings get_default () {
            if (instance == null) {
                instance = new AppSettings ();
            }
            return instance;
        }

        private AppSettings () {
            base ("com.github.naz013.tasks");
        }
    }
}
