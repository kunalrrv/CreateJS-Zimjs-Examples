
package com.danzen.utilities {
	
	import flash.utils.ByteArray;
	
	public class DynamicObject {
		
		
		public static function compare(a:Object, b:Object):Boolean {
			var myBA:ByteArray = new ByteArray();
			myBA.writeObject(a);
			var myBA2:ByteArray = new ByteArray();
			myBA2.writeObject(b);			
			
			var size:uint = myBA.length;
			if (myBA.length == myBA2.length) {
				myBA.position = 0;
				myBA2.position = 0; 								
				var count:Number = 0;
				while (myBA.position < size) {
					count++
					if (myBA.readByte() != myBA2.readByte()) {						
						return false;
					}
				}    
				return true;                        
			}
			return false;
		}
		
		public static function difference(a:Object,b:Object):Number {
			var diff:Number = 0;
			for (var i:Object in a) {
				diff += Math.abs(Number(a[i] - b[i]));
			}
			return diff;					
		}		
		
		public static function copy(source:Object):* {
			var myBA:ByteArray = new ByteArray();
			myBA.writeObject(source);
			myBA.position = 0;
			return(myBA.readObject());
		}		
	}
}