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
    	
    	public static string to_label_from_seconds(int64 seconds) {
    	    return to_label(from_seconds(seconds));
    	}
    	
    	public static string to_label(string input) {
    	    var tmp = "";
    		if (input.length < LENGTH) {
    			for (int i = 0; i < LENGTH - input.length; i++) {
    				tmp = tmp + ZERO;
    			}
    		}
    		tmp = tmp + input;
    		// Logger.log(@"create_label: tmp -> $tmp");
    		
    		var d01 = tmp.substring(0, 2);
    		var d23 = tmp.substring(2, 2);
    		var d45 = tmp.substring(4, 2);
    		
    		var hours = int.parse(d01);
    		var minutes = int.parse(d23);
    		
    		string h = _("hrs");
    		string m = _("mins");
    		string s = _("sec");
    		
    		if (hours > 0) {
    			return @"$d01 $h $d23 $m $d45 $s";
    		} else if (minutes > 0) {
    			return @"$d23 $m $d45 $s";
    		} else {
    			return @"$d45 $s";
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
		
		public static int64 to_seconds(string input) {
		    var tmp = "";
    		if (input.length < LENGTH) {
    			for (int i = 0; i < LENGTH - input.length; i++) {
    				tmp = tmp + ZERO;
    			}
    		}
    		tmp = tmp + input;
    		
    		var d01 = tmp.substring(0, 2);
    		var d23 = tmp.substring(2, 2);
    		var d45 = tmp.substring(4, 2);
    		
    		int64 secs = 0;
    		secs += int.parse(d01) * HOUR;
    		secs += int.parse(d23) * MINUTE;
    		secs += int.parse(d45);
    		
    		// Logger.log(@"to_seconds: tmp -> $tmp, secs -> $secs");
    		
    		return secs;
		}
	}
}
