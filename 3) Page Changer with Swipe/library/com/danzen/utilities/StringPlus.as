
package com.danzen.utilities {
	
	public class StringPlus {
		
		public static function firstUpper(s:String) {
			return s.substr(0,1).toUpperCase()+s.substr(1,s.length-1);
		}
		
		public static function convertURL(s:String, underlineMe:Boolean=true) {

			// changes http://www.someURL.com to <a href="http://www.someURL.com" target="new1">http://www.someURL</a>
			
			var i:uint;
			var j:uint;
			var t:String;
			var t2:String;
			var lines:Array;
			var a:Array;
			var a2:Array;
			var u:String;
			var added1:String = "";
			var added2:String = "";
			
			lines = s.split(/[\n\r]/);
			if (underlineMe) {
				added1 = "<u>";
				added2 = "</u>";
			}
			
			for (j=0; j<lines.length; j++) {
			
				a = lines[j].split("http://");
				if (a.length > 1) {
					for (i=1; i<a.length; i++) {
						t = a[i];
						if (t != "") {
							a2 = t.split(" ");						
							u = a2[0];
							a2[0] = "<a href=\"http://" + u + "\" target=\"pop"+i+j+"\">"+added1+"http://" + u + ""+added2+"</a>";
							a[i] = a2.join(" ");
						}			
					}
				}
				lines[j] = a.join("");
			}
			
			return lines.join("\n");
		}		
	}
}