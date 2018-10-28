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
    	            handle_event(event.id);
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
    	
    	private void handle_event(uint id) {
    	    var found = find_event(id);
            if (found != null) {
                found.is_active = false;
	            if (found.repeat_time > 0) {
	            	DateTime dt = new DateTime.now_local ();
                	dt = dt.add_seconds((double) found.repeat_time);
                	found.estimated_time = dt.to_unix();
                	found.is_active = true;
                	start_repeat(found, found.repeat_time);
	            }
                show_notification(found);
            }
            running_tasks.unset(id);
    	}
    	
    	private void start_repeat(Event event, int64 seconds) {
    	    stop_task(event);
    	    var thread_id = Timeout.add_seconds((uint) seconds, () => {
	            Logger.log(@"Repeat task execution complete: id -> $(event.id)");
	            handle_event(event.id);
	            return false;
	        });
	        
	        Logger.log(@"start_task: ti -> $thread_id, ei -> $(event.id)");
	        running_tasks.set(event.id, thread_id);
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
