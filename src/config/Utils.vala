namespace Tasks {
	public class Utils : GLib.Object {
	
	    public const int64 MINUTE = 60;
    	public const int64 HOUR = MINUTE * 60;
    	public const string ZERO = "0";
    	public const int LENGTH = 6;
    	
    	public static int64 calculate_estimate_timer(int64 seconds) {
    	    var dt = new DateTime.now_local();
        	dt = dt.add_seconds((double) seconds);
        	return dt.to_unix();
    	}
    	
    	public static string to_label_from_seconds(int64 all_seconds) {
    	    int hours = (int) (all_seconds / HOUR);
    	    int minutes = (int) ((all_seconds - (hours * HOUR)) / MINUTE);
    	    int seconds = (int) (all_seconds - (hours * HOUR) - (minutes * MINUTE));
    	    return to_label(hours, minutes, seconds);
    	}
    	
    	public static string to_label(int hours, int minutes, int seconds) {
    	    string h = _("hrs");
    		string m = _("mins");
    		string s = _("sec");
    		if (hours > 0) {
    			return @"$hours $h $minutes $m $seconds $s";
    		} else if (minutes > 0) {
    			return @"$minutes $m $seconds $s";
    		} else {
    			return @"$seconds $s";
    		}
    	}
		
		public static string from_seconds (int64 seconds) {
			var hours = seconds / HOUR;
    	    var minutes = (seconds - (hours * HOUR)) / MINUTE;
    	    var secs = (seconds - (hours * HOUR) - (minutes * MINUTE));
    	    var tmp = "";
    	    if (hours > 0){
    	        tmp = tmp + @"$(hours)";
    	    }
    	    if (tmp.length > 0) {
    	        if (minutes < 10) {
        	        tmp = tmp + @"0$(minutes)";
        	    } else {
        	        tmp = tmp + @"$(minutes)";
        	    }
    	    } else {
    	        tmp = tmp + @"$(minutes)";
    	    }
    	    if (tmp.length > 0) {
    	        if (secs < 10) {
        	        tmp = tmp + @"0$(secs)";
        	    } else {
        	        tmp = tmp + @"$(secs)";
        	    }
    	    } else {
    	        tmp = tmp + @"$(secs)";
    	    }
    	    return tmp;
		}
		
		public static int64 to_seconds(int hours, int minutes, int seconds) {
    		int64 secs = 0;
    		secs += hours * HOUR;
    		secs += minutes * MINUTE;
    		secs += seconds;
    		return secs;
		}
	}
}
