namespace Tasks {
    public class TasksController {
        
        public signal Event find_event(uint id);
        public signal void show_notification(Event event);
        
        private Gee.HashMap<uint, uint> running_tasks = new Gee.HashMap<uint, uint>();
    	
    	public TasksController() {
    		
    	}
    	
    	public void init_tasks(Gee.ArrayList<Event> tasks) {
    		running_tasks.clear();
    		
    		for (int i = 0; i < tasks.size; i++) {
    		    Event event = tasks.get(i);
    		    start_task(event);
    		}
    	}
    	
    	public void start_task(Event event) {
    	    stop_task(event);
    	    
    	    if (event.is_active && event.has_reminder) {
    	        var thread_id = Timeout.add_seconds(calculate_left_secconds(event), () => {
    	            Logger.log(@"Task execution complete: id -> $(event.id)");
    	            var found = find_event(event.id);
    	            if (found != null) {
    	                show_notification(found);
    	            }
    	            running_tasks.unset(event.id);
    	            return false;
    	        });
    	        
    	        Logger.log(@"start_task: ti -> $thread_id, ei -> $(event.id)");
    	        
    	        running_tasks.set(event.id, thread_id);
    		}
    	}
    	
    	public void stop_task(Event event) {
    	    print_keys(running_tasks.keys);
    	    if (running_tasks.has_key(event.id)) {
    	        uint thread_id = 0;
    	        running_tasks.unset(event.id, out thread_id);
    	        
    	        Logger.log(@"stop_task: ti -> $thread_id, ei -> $(event.id)");
    	        Source.remove(thread_id);
    	    }
    	}
    	
    	private void print_keys(Gee.Set<uint> keys) {
    	    Logger.log(@"print_keys: start");
    	    var array = keys.to_array();
    	    for (int i = 0; i < keys.size; i++) {
    		    Logger.log(@"print_keys: key -> $(array[i])");
    		}
    		Logger.log(@"print_keys: end");
    	}
    	
    	private uint calculate_left_secconds(Event event) {
    	    uint seconds = 0;
    	    if (event.event_type == Event.DATE) {
    	        var current = new DateTime.now_local ();
    	        var dt = new DateTime.from_unix_local(event.due_date_time);
    	        var diff = dt.difference(current);
    	        Logger.log(@"calculate_left_secconds: diff -> $diff");
    	        seconds = (uint) (diff / TimeSpan.SECOND);
    	    } else if (event.event_type == Event.TIMER) {
    	        seconds = (uint) event.timer_time;
    	    }
    	    Logger.log(@"calculate_left_secconds: $seconds");
    	    if (seconds < 0) {
    	    	seconds = 0;
    	    } else if (event.before_time > 0) {
    	        seconds = seconds - (uint) event.before_time;
    	    }
    	    return seconds;
    	}
    }
}
