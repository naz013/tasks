namespace Tasks {

    public class EmptyView : Gtk.EventBox {
        
        public EmptyView() {
            Gtk.Label empty_label = new Gtk.Label ("");
            empty_label.set_use_markup (true);
            empty_label.set_line_wrap (true);
            empty_label.set_markup (_("No tasks, use \"Plus\" button to add one\n\n<b>Control+N</b> - Create task\n<b>Control+F</b> - Set fullscreen\n<b>Control+Q</b> - Exit"));
            empty_label.set_justify(Gtk.Justification.CENTER);
            empty_label.get_style_context().add_class("empty_label");
            empty_label.expand = true;
            add(empty_label);
        }
    }
}
