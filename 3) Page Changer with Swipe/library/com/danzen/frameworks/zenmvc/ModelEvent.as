
package com.danzen.frameworks.zenmvc {
	
	import flash.events.*
	
	public class ModelEvent extends Event {		
		
		public static const COMPLETE:String = "complete";
		
		public var data:Object;
		public var error:Boolean;
		private var t:String;
		private var b:Boolean;
		private var c:Boolean;
		
		public function ModelEvent(type:String,
								 theData:Object,
								 theError:Boolean,
								 bubbles:Boolean = false,
								 cancelable:Boolean = false) {
			t = type;
			b = bubbles;
			c = cancelable;			
			super (t,b,c);
			data = theData;
			error = theError;

		}
		
		public override function clone():Event {
			return new ModelEvent(t,data,error,b,c);
		}
		
		public override function toString():String {
			return formatToString("ModelEvent","type","data","Error","bubbles","cancelable","eventPhase");
		}	
	}
}