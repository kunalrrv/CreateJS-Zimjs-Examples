
package com.danzen.frameworks.zenmvc {
	
	import flash.events.*
	
	public class ViewEvent extends Event {		
		
		public static const INPUT:String = "input";
		
		public var viewTarget:Object;
		public var viewCurrentTarget:Object;
		private var t:String;
		private var b:Boolean;
		private var c:Boolean;
		
		public function ViewEvent(type:String,
								 theViewTarget:Object,
								 theViewCurrentTarget:Object,
								 bubbles:Boolean = false,
								 cancelable:Boolean = false) {
			t = type;
			b = bubbles;
			c = cancelable;			
			super (t,b,c);
			viewTarget = theViewTarget;
			viewCurrentTarget = theViewCurrentTarget;

		}
		
		public override function clone():Event {
			return new ViewEvent(t,viewTarget,viewCurrentTarget,b,c);
		}
		
		public override function toString():String {
			return formatToString("ViewEvent","type","viewTarget","viewCurrentTarget","bubbles","cancelable","eventPhase");
		}	
	}
}