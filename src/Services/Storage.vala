
namespace Tasks {
    public class Storage : Object {
        public string color;
        public int64 x;
        public int64 y;
        public string content;
        public string title;

        public Storage() {}

        public Storage.from_storage(int64 x, int64 y, string color, string message, string title) {
            this.color = color;
            this.content = message;
            this.x = x;
            this.y = y;
            this.title = title;
        }
    }
}
